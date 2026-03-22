
#let pad_left(pad_char, desired_lenght, number) = {
  let num_str = str(number)
  let padding_needed = calc.max(0, desired_lenght - num_str.len())
  pad_char * padding_needed + num_str
}

#let heading_with_id(id, content) = [
  #content
]
