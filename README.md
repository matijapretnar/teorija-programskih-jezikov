# Teorija programskih jezikov

V tem repozitoriju se zbirajo gradiva za predmet Teorija programskih jezikov na magistrskem študijuna [Fakulteti za matematiko in fiziko](https://www.fmf.uni-lj.si/).

## Zapiski

Viri zapiskov se nahajajo v mapi `zapiski`. Za izdelavo HTML datotek si morate namestiti paket [`jupyter-book`](https://jupyterbook.org/). Nato pa pokličete

```bash
jupyter-book build zapiski
```

Pri tem je pomembno, da je nameščena verzija `jupyter-book`-a pred `2.0` (npr. z `pip install "jupyter-book<2"`), ker je konfiguracija zapiskov še s staro verzijo.

Če se ne želite matrati z zaganjanjem `ocaml-jupyter`-a, lahko v `zapiski/_config.yml` odkomentirate vrstici z `execute`.

Če imate ustrezne pravice, lahko HTML najenostavneje objavite kar prek [GitHub pages](https://pages.github.com) tako, da si namestite še paket [`ghp-import`](https://github.com/c-w/ghp-import) in poženete

```bash
ghp-import --no-jekyll --no-history --force --push zapiski/_build/html
```
