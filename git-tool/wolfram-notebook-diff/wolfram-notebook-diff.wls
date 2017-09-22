#!/usr/bin/env wolframscript -function -signature String String

<<AuthorTools`;

(*UsingFrontEnd[
    With[
        {diffnb = NotebookDiff[#1, #2]},
        With[{nb = NotebookPut[diffnb]}, NotebookOpen[nb]]
    ]
]&*)

UsingFrontEnd[
    With[
        {
		    diffnb = NotebookDiff[#1, #2],
		    diffnbFile = FileNameJoin[{$TemporaryDirectory, "wolfram_notebook_diff_result.nb"}]
        },
        Export[diffnbFile, diffnb, "Notebook"]
    ]
]&
