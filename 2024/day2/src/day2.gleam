import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/string
import simplifile

pub fn main() {
  // read the input file
  let input = "./src/input.txt"
  let assert Ok(input) = simplifile.read(input)

  // parse each row into a list of ints
  let rows =
    string.split(string.trim(input), "\n")
    |> list.map(string.split(_, " "))
    |> list.map(list.filter_map(_, parse_int))

  part1(rows)
  part2(rows)
}

fn part1(rows: List(List(Int))) {
  // validate and output the number of valid rows after
  // splitting the row into tuples for comparing
  let valid_rows =
    rows
    |> list.count(validate_row)
    |> int.to_string

  io.println("Part 1: " <> valid_rows)
}

fn part2(rows: List(List(Int))) {
  // lazily calculate every permutation of the row that has an item missing and attempt to validate it 
  let valid_rows =
    rows
    |> list.count(fn(x) {
      list.any(list.combinations(x, list.length(x) - 1), validate_row)
    })
    |> int.to_string

  io.println("Part 2: " <> valid_rows)
}

fn parse_int(s: String) -> Result(Int, String) {
  case int.parse(s) {
    Ok(int) -> Ok(int)
    Error(_) -> Error("Failed to parse: " <> s)
  }
}

// rows must be entirely ascending or descending
// and the difference between each pair must be between 1 and 3
fn validate_row(row: List(Int)) -> Bool {
  let pairs = row |> list.window_by_2
  let valid_step = list.all(pairs, is_valid_range)
  let valid_order = is_order(pairs, order.Lt) || is_order(pairs, order.Gt)
  { valid_step && valid_order }
}

fn is_order(row: List(#(Int, Int)), o: order.Order) -> Bool {
  list.all(row, fn(x) { int.compare(x.0, x.1) == o })
}

fn is_valid_range(a: #(Int, Int)) -> Bool {
  let abs = int.absolute_value(a.0 - a.1)
  abs <= 3 && abs >= 1
}
