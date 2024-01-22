---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.12
    jupytext_version: 1.8.0
kernelspec:
  display_name: OCaml 4.11
  language: OCaml
  name: ocaml-jupyter
---

# Vaje

```{code-cell}
:tags: [remove-cell, remove-stdout]

(* Ko se v Jupytru prvič požene OCaml, program Findlib izpiše neko sporočilo.
   Da se to sporočilo ne bi videlo v zapiskih, je tu ta celica, ki sproži izpis,
   vendar ima nastavljeno, da je v zapiskih v celoti skrita. *)
```

## Naloga 1

1. Napišite prestreznik `mute`, ki prestreže vgrajeni `Print` in prepreči izpis. Program naj nadaljuje nemoteno.

2. Napišite prestreznik `shift_text_right n`, ki vse izpisano besedilo zamakne v desno za `n` mest.

3. Prestreznik `underline` vsako izpisano vrstico podčrta (tako da v novi vrstici izpiše primerno število znakov `-`).

4. Prestreznik `custom_separator sep` naj poskrbi, da se ločeno izpisani tekst ne loči z `\n` temveč separatorjem `sep`.

5. Napišite prestreznik `counter limit`, ki šteje izpise in vrne rezultat, samo, če je bilo izpisanih manj kot `limit` znakov. Če je bilo izpisanih več, naj vrne `None`.

6. Popravite zgornje prestreznike, da bodo ponovno sprožili učinke `Print`, ki ga bo ujel limitni prestreznik.

## Naloga 2

1. Napišite učinka `Get : unit -> int` in `Put : int -> unit` in program, ki ju smiselno uporablja.

2. Napišite prestreznik `state`, ki program ustrezno implementira učinka `Get` in `Put` v monadični obliki - izračun pretvori v funkcijo, ki sprejme začetno vrednost stanja in vrne rezultat.


## Naloga 3

Vzemi drevo, ki ga definira naslednji tip:

```ocaml
type 'a tree
 = Empty
 | Node of tree * 'a * tree

type direction = Left | Right
```

in učinek `Pick : unit -> direction`.

2. Napišite funkcijo `explore : int tree  -> int`, ki raziskuje drevo in podatke združuje s pomočjo globalne funkcije `op : 'a -> int -> 'a`.
   Raziskovanje praznega drevesa naj vrne `0`, raziskovanje nepraznega pa naj najprej izvede učinek `Pick` in glede na rezultat izbere levo ali desno poddrevo, nadaljuje raziskovanje tega poddrevesa in vrne rezultat združen z vrednostjo v korenu.

3. Napišite prestreznike in pripadajočo funkcijo `op`, ki glede na funkcijo `explore` vrnejo naslednje rezultate:
    - Vrednost minimalne poti v drevesu
    - Vrednost maksimalne poti v drevesu
    - Število vseh poti v drevesu
    - Vrednosti vseh poti v drevesu
    - Povprečno vrednost poti v drevesu

## Naloga 4

Želimo narediti prestreznik za memoizacijo. Že izračunane vrednosti bomo (neučinkovito) hranili v seznamu parov.

1. Napišite funkciji za delo s seznami parov `find : 'a -> ('a * 'b) list -> 'b option` in `save : 'a -> 'b -> ('a * 'b) list -> ('a * 'b) list`.

2. Da si poenostavimo življenje, se osredotočimo zgolj na funkcije `int -> int`. V nadaljevanju uporabljamo preimenovanji `type arg = int` in `type result = int`.
  Naša memoizacija bo potrebovala pomnilnik, zato bomo zanj definirali poseben prestreznik. Definirajte učinka `Lookup : arg -> result option` in `Remember : arg * result -> unit`. Nato zanju napišite prestreznik `memory`, ki upravlja s pomnilnikom tipa `(arg * result) list`.

3. Sedaj lahko funkcije že uporabljajo pomnilnik za memoizacijo, vendar bi želeli, da je memoizacija funkcije zgolj eno od možnih izvajanj. Zato definirajte učinek `Evaluate : ((int -> int) * int) -> int`, ki sprejme funkcijo in argument, ter nam vrne rezultat.
  Funkcij sedaj ne kličemo več kot `f x` temveč kot `perform (Evaluate (f, x))` (priporočam, da si ustvarite pomožno funkcijo `eval f x = ...` za lepšo sintakso). Napišite prestreznik `no_memo`, ki funkcijo izvede, kot bi se izvedla sicer. Nato napišite še prestreznik `memo`, ki funkcijo memoizira.

**Namig:** Če želite rekurzivne prestreznike, jih definirajte kot `let rec h () = handler ...` kjer jih lahko sedaj v telesu definicije uporabite z `with h () handle ...`.

## Naloga 5

Generatorji so funkcije, ki zaporedoma uporabljajo učinek `Yield : int -> unit`.

1. Napišite funkcijo, ki generira vsa naravna števila.

2. Napišite funkcijo `collect n gen`, ki iz generatorja `gen` pobere prvih `n` vrednosti.

3. Napišite prestreznik `generator gen`, ki na zahtevo `Generate : unit -> int` generira novo vrednost iz generatorja `gen`.

**Namig:** Eden od možnih načinov je, da z dodatnim prestreznikom generatorje iz tipa `unit -> unit!{Yield}` pretvorite v tip `unit -> gen`. Tu je `gen` novo definiran tip, ki označuje, da je generator bodisi končal, bodisi pa je proizvedel element in svoje posodobljeno stanje (ponovno tipa `unit -> gen`). Če potrebujete, ima Eff vgrajeno funkcijo `failwith msg`.
