let read_source filename =
  let channel = open_in filename in
  let source = really_input_string channel (in_channel_length channel) in
  close_in channel;
  source

let () =
  match Array.to_list Sys.argv with
  | [ _miniml; filename ] ->
    let source = read_source filename in
    let e = Parser.parse source in
    print_endline "MALI KORAKI:";
    Interpreter.small_step e;
    print_endline "VELIKI KORAKI:";
    Interpreter.big_step e
  | _ ->
      let miniml = Sys.executable_name in
      failwith
        (Printf.sprintf
           "Run MINIML as '%s <filename>.lam'" miniml)
