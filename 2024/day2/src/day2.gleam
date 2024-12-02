import gleam/bool
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
    string.split(input, "\n")
    |> list.filter(fn(x) { string.trim(x) != "" })
    |> list.map(string.split(_, " "))
    |> list.map(list.filter_map(_, parse_int))

  part1(rows)
}

fn part1(rows: List(List(Int))) {
  // validate and output the number of valid rows after
  // splitting the row into tuples for comparing
  let valid_rows =
    rows
    |> list.map(list.window_by_2)
    |> list.map(validate_row)
    |> list.count(fn(x) { x == True })
    |> int.to_string

  io.println("Part 1: " <> valid_rows)
}

fn parse_int(s: String) -> Result(Int, String) {
  case int.parse(s) {
    Ok(int) -> Ok(int)
    Error(_) -> Error("Failed to parse: " <> s)
  }
}

fn validate_row(row: List(#(Int, Int))) -> Bool {
  let valid_step =
    row |> list.map(compare_is_valid) |> list.all(fn(x) { x == True })
  let valid_order = is_ascending(row) || is_descending(row)
  { valid_step && valid_order }
}

fn compare_is_valid(a: #(Int, Int)) -> Bool {
  let abs = int.absolute_value(a.0 - a.1)
  let is_ordered = a.0 > a.1 || a.0 < a.1
  let valid_step_size = abs <= 3 && abs >= 1
  { valid_step_size && is_ordered }
}

fn is_ascending(row: List(#(Int, Int))) -> Bool {
  row
  |> list.map(fn(x) {
    use <- bool.guard(x.0 < x.1, False)
    True
  })
  row
  |> list.map(fn(x) { int.compare(x.0, x.1) })
  |> list.all(fn(x) { x == order.Lt })
}

fn is_descending(row: List(#(Int, Int))) -> Bool {
  row
  |> list.map(fn(x) { int.compare(x.0, x.1) })
  |> list.all(fn(x) { x == order.Gt })
}
