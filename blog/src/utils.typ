#import "../slugify.typ": slugify

#let pad_left(pad_char, desired_lenght, number) = {
  let num_str = str(number)
  let padding_needed = calc.max(0, desired_lenght - num_str.len())
  pad_char * padding_needed + num_str
}

/* build html id given post number (without `#`)
  eg 1 --> "post-001"
*/

#let post_id(num) = str("post-" + pad_left("0", 3, num))
