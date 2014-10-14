(defun convert-english-chinese-punctuation (p1 p2 &optional ξ-to-direction)
  "Replace punctuation from/to English/Chinese Unicode symbols.

When called interactively, do current text block (paragraph) or text selection. The conversion direction is automatically determined.

If `universal-argument' is called:

 no C-u → Automatic.
 C-u → to English
 C-u 1 → to English
 C-u 2 → to Chinese

When called in lisp code, p1 p2 are region begin/end positions. ξ-to-direction must be any of the following values: 「\"chinese\"」, 「\"english\"」, 「\"auto\"」.

See also: `remove-punctuation-trailing-redundant-space'."
  
  (interactive
   (let ( (bds (get-selection-or-unit 'block)))
     (list (elt bds 1) (elt bds 2)
           (cond
            ((equal current-prefix-arg nil) "auto")
            ((equal current-prefix-arg '(4)) "english")
            ((equal current-prefix-arg 1) "english")
            ((equal current-prefix-arg 2) "chinese")
            (t "chinese")
            )
           ) ) )
  (let ((ξ-english-chinese-punctuation-map
         [
          [". " "。"]
          [".\n" "。\n"]
          ["," "，"]
          [": " "："]
          ["; " "；"]
          ["?" "？"] ; no space after
          ["! " "！"]

          ;; for inside HTML
          [".</" "。</"]
          ["?</" "？</"]
          [":</" "：</"]
          ]
         ))

    (replace-pairs-region p1 p2
                              (cond
                               ((string= ξ-to-direction "chinese") ξ-english-chinese-punctuation-map)
                               ((string= ξ-to-direction "english") (mapcar (lambda (ξpair) (vector (elt ξpair 1) (elt ξpair 0))) ξ-english-chinese-punctuation-map))
                               ((string= ξ-to-direction "auto")
                                (if (string-match "。\\|，\\|？\\|！\\|：" (buffer-substring-no-properties p1 p2))
                                    (mapcar (lambda (ξpair) (vector (elt ξpair 1) (elt ξpair 0))) ξ-english-chinese-punctuation-map)
                                  ξ-english-chinese-punctuation-map
                                  ))

                               (t (error "Your 3rd argument 「%s」 isn't valid." ξ-to-direction)) ) ) ) )