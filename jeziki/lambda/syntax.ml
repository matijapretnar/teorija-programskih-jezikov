type ident = Ident of string

type exp =
  | Var of ident
  | Lambda of ident * exp
  | Apply of exp * exp
  | Zero
  | Succ

let let_in (x, e1, e2) = Apply (Lambda (x, e2), e1)

let rec free_vars = function
  | Var x -> [ x ]
  | Lambda (x, e) -> List.filter (fun y -> y <> x) (free_vars e)
  | Apply (e1, e2) -> free_vars e1 @ free_vars e2
  | Zero | Succ -> []

let rec subst_exp sbst = function
  | Var x as e -> (
      match List.assoc_opt x sbst with None -> e | Some e' -> e')
  | Lambda (x, e) ->
      List.iter (fun (_, e') -> assert (not (List.mem x (free_vars e')))) sbst;
      let sbst' = List.remove_assoc x sbst in
      Lambda (x, subst_exp sbst' e)
  | Apply (e1, e2) -> Apply (subst_exp sbst e1, subst_exp sbst e2)
  | Zero -> Zero
  | Succ -> Succ

let string_of_ident (Ident x) = x

let rec string_of_exp2 = function
  | Lambda (x, e) -> "\\" ^ string_of_ident x ^ ". " ^ string_of_exp2 e
  | e -> string_of_exp1 e

and string_of_exp1 = function
  | Apply (e1, e2) -> string_of_exp1 e1 ^ " " ^ string_of_exp0 e2
  | e -> string_of_exp0 e

and string_of_exp0 = function
  | Var x -> string_of_ident x
  | Zero -> "Z"
  | Succ -> "S"
  | e -> "(" ^ string_of_exp2 e ^ ")"

let string_of_exp = string_of_exp2
