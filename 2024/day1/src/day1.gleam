import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  // read the input file
  let input = "./src/input.txt"
  let assert Ok(input) = simplifile.read(input)

  // for each line, get a list of integers
  let cols =
    string.split(input, "\n")
    |> list.map(split_columns)
    |> list.transpose
    |> list.map(fn(l) { list.sort(l, by: int.compare) })

  // zip the two columns together into a list of tuples
  let zipped = case list.take(cols, 2) {
    [a, b] -> list.zip(a, b)
    _ -> []
  }

  // do the thing
  part1(zipped)
  part2(zipped, cols)
}

pub fn part1(zipped: List(#(Int, Int))) {
  io.print("Part 1: ")
  // calculate the sum of the absolute differences
  zipped
  |> list.map(fn(tuple) {
    // return the abs difference between the values in the current row
    let #(a, b) = tuple
    int.absolute_value(a - b)
  })
  |> int.sum
  |> int.to_string
  |> io.println
}

pub fn part2(zipped: List(#(Int, Int)), cols: List(List(Int))) {
  io.print("Part 2: ")
  // get the similarity value of the two columns
  zipped
  |> list.map(fn(tuple) {
    case list.last(cols) {
      // we use the left value of the tuple (tuple.0) to get the similarity score
      Ok(last) -> similarity_score(last, tuple.0)
      Error(Nil) -> 0
    }
  })
  |> int.sum
  |> int.to_string
  |> io.println
}

// split the given string into a list of integers
fn split_columns(line: String) {
  string.split(line, " ")
  |> list.filter_map(parse_int)
}

// string to int
fn parse_int(s: String) -> Result(Int, String) {
  case int.parse(s) {
    Ok(int) -> Ok(int)
    Error(_) -> Error("Failed to parse: " <> s)
  }
}

// calculate the similarity score by multiplying a by the number of times it occurs in the list
fn similarity_score(list: List(Int), a: Int) {
  list.count(list, fn(x) { x == a })
  |> int.multiply(a)
}
