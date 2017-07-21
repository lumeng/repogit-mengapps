#!/usr/bin/env wolframscript -function -signature City City

(*
## Usage examples:

* get distance between NYC and Boston in miles:

    $ ./city-distance.wls NYC Boston
    264585.16723714204
*)

GeoDistance[#1, #2]&
