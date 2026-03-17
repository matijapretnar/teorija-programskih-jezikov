module S = Syntax

let rec eval_exp = function
  | S.Var _ -> failwith "Expected a closed term"
  | (S.Zero | S.Succ | S.Lambda _) as e -> e
  | S.Apply (e1, e2) -> (
      let f = eval_exp e1 and v = eval_exp e2 in
      match f with
      | S.Lambda (x, e) -> eval_exp (S.subst_exp [ (x, v) ] e)
      | S.Succ -> S.Apply (S.Succ, v)
      | _ -> failwith "Function expected")

let rec is_value = function
  | S.Lambda _ | S.Zero | S.Succ -> true
  | S.Apply (S.Succ, v) -> is_value v
  | S.Var _ | S.Apply _ -> false

let rec step = function
  | S.Var _ | S.Lambda _ | S.Zero | S.Succ ->
      failwith "Expected a non-terminal expression"
  | S.Apply (S.Lambda (x, e), v) when is_value v -> S.subst_exp [ (x, v) ] e
  | S.Apply (f, e) when is_value f -> S.Apply (f, step e)
  | S.Apply (e1, e2) -> S.Apply (step e1, e2)

let big_step e =
  let v = eval_exp e in
  print_endline (S.string_of_exp v)

let rec small_step e =
  print_endline (S.string_of_exp e);
  if not (is_value e) then (
    print_endline "  ~>";
    small_step (step e))
