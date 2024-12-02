import gleam/io
import gleam/list

pub fn main() {
  // read the input file
  let y = #(1, 3)
  let x = [#(1, 2), #(3, 4), y, #(5, 6)]

  case x {
    [_, y, ..] -> io.debug("found y")
    [] -> io.debug("empty")
    _ -> io.debug("not found")
  }

  x |> list.pop(fn(x) { x == y }) |> io.debug
  x |> io.debug
}
