let read_source filename =
  let channel = open_in filename in
  let source = really_input_string channel (in_channel_length channel) in
  close_in channel;
  source

let print_header header = Format.printf "%s\n%s\n" header (String.make 80 '=')

let () =
  match Array.to_list Sys.argv with
  | [ _miniml; filename ] ->
      let source = read_source filename in
      let e = Parser.parse source in
      print_header "DOLOČANJE TIPA";
      Typechecker.check_type e
      (* print_header "MALI KORAKI";
         Interpreter.small_step e;
         print_header "VELIKI KORAKI";
         Interpreter.big_step e *)
  | _ ->
      let hminiml = Sys.executable_name in
      failwith (Printf.sprintf "Run HMINIML as '%s <filename>.lam'" hminiml)
