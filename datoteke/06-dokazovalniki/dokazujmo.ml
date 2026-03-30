type empty
type ('a, 'b) sum = Inl of 'a | Inr of 'b

(*
    Dokažimo
        P ∧ (Q ∨ R) ⇒ (P ∧ Q) ∨ (P ∧ R)
    tako, da skonstruiramo izraz tipa
        'a * ('b, 'c) sum -> ('a * 'b, 'a * 'c) sum
*)

let distributivnost : 'a * ('b, 'c) sum -> ('a * 'b, 'a * 'c) sum =
    fun (a, b_ali_c) ->
        match b_ali_c with
        | Inl b -> Inl (a, b)
        | Inr c -> Inr (a, c)

(* 0. "težava": nerodno pisanje dokazov - če se vam ne zdi nerodno, vam bo všeč Agda *)

(* 1. težava: izjeme in divergenca *)

let a_je_vedno_res : 'a = failwith "Boom"

let rec iz_a_sledi_b (dokaz_a : 'a) : 'b =
    iz_a_sledi_b dokaz_a

(* 2. težava: kaj pa predikati? *)

(* 3. težava: neučinkovitost, zaradi izvajanja "dokazov" *)
