type empty
type ('a, 'b) sum = Inl of 'a | Inr of 'b
type 'a not = 'a -> empty

(*
    Dokažimo
        P ∧ Q ⇒ Q ∧ P
    tako, da skonstruiramo izraz tipa
        'a * 'b -> 'b * 'a
*)

let konjunkcija_komutira (dokaz_a, dokaz_b) = (dokaz_b, dokaz_a)

(*
    Dokažimo
        P ∧ (Q ∨ R) ⇒ (P ∧ Q) ∨ (P ∧ R)
    tako, da skonstruiramo izraz tipa
        'a * ('b, 'c) sum -> ('a * 'b, 'a * 'c) sum
*)

let distributivnost : 'a * ('b, 'c) sum -> ('a * 'b, 'a * 'c) sum =
 fun (dokaz_a, dokaz_b_ali_c) ->
  match dokaz_b_ali_c with
  | Inl dokaz_b -> Inl (dokaz_a, dokaz_b)
  | Inr dokaz_c -> Inr (dokaz_a, dokaz_c)

(*
    Dokažimo
        ¬P ∨ ¬Q ⇒ ¬(P ∧ Q)
    tako, da skonstruiramo izraz tipa
        ('a not, 'b not) sum -> ('a * 'b) not
*)

let negacija_konjunkcije (dokaz_ne_a_ali_ne_b : ('a not, 'b not) sum) :
    ('a * 'b) not =
  match dokaz_ne_a_ali_ne_b with
  | Inl dokaz_ne_a -> fun (dokaz_a, dokaz_b) -> dokaz_ne_a dokaz_a
  | Inr dokaz_ne_b -> fun (dokaz_a, dokaz_b) -> dokaz_ne_b dokaz_b

(* 0. "težava": nerodno pisanje dokazov - če se vam ne zdi nerodno, vam bo všeč Agda *)

(* 1. težava: izjeme in divergenca *)

let dokaz_a : 'a = failwith "Boom"
let rec dokaz_iz_a_sledi_b (dokaz_a : 'a) : 'b = dokaz_iz_a_sledi_b dokaz_a

(* 2. težava: kaj pa predikati? *)

(* 3. težava: neučinkovitost, zaradi izvajanja "dokazov" *)
