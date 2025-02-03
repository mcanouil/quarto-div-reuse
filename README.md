# Div-reuse Extension For Quarto

This is a Quarto extension applying the concept of "code reuse" to the content of a Markdown fenced div.

## Installing

```bash
quarto add mcanouil/div-reuse
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

## Using

To use the extension, add the following to your document's front matter:

```yaml
filters:
  - div-reuse
```

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).

Outputs of `example.qmd`:

- [HTML](https://m.canouil.dev/quarto-div-reuse/)
- [Typst/PDF](https://m.canouil.dev/quarto-div-reuse/div-reuse-typst.pdf)
- [LaTeX/PDF](https://m.canouil.dev/quarto-div-reuse/div-reuse-latex.pdf)
- [Word/Docx](https://m.canouil.dev/quarto-div-reuse/div-reuse-openxml.docx)
- [Reveal.js](https://m.canouil.dev/quarto-div-reuse/div-reuse-revealjs.html)
- [Beamer/PDF](https://m.canouil.dev/quarto-div-reuse/div-reuse-beamer.pdf)
- [PowerPoint/Pptx](https://m.canouil.dev/quarto-div-reuse/div-reuse-pptx.pptx)
