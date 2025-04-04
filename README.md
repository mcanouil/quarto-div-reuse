# Div-reuse Extension For Quarto

This is a Quarto extension applying the concept of "code reuse" to the content of a Markdown fenced div.

## Installing

```bash
quarto add mcanouil/quarto-div-reuse
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

## Using

To use the extension, add the following to your document's front matter:

```yaml
filters:
  - div-reuse
```

If you plan to reuse content processed by Quarto, such as cross-referenced content, make sure the filter is applied last.

```yaml
filters:
  - quarto
  - div-reuse
```

Then, you can reuse any fenced div by using their ID in the following way:

```markdown
## Original Div

::: {#my-div}
{{< lipsum >}}
:::

## Reused Div

::: {reuse="my-div"}
:::
```

> [!IMPORTANT]
> The "reuse" attribute acts like a copy-paste of the original `div` content.
> Consequently, content and their attributes, including the ID, are duplicated.
> This can result in unexpected behaviour if the same ID is used multiple times within the same document.
>
> Therefore, it is recommended to use the "reuse" attribute primarily with text content.

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
