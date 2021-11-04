% My epic presentation
% Myself
% today

---
slide-level: 2
aspectratio: 169

theme: metropolis
colortheme: owl

# Light theme
#colorthemeoptions: snowy
#minted:
#	style: perldoc

links-as-notes: true
beameroption: "show notes on second screen=right"

toc: true
lang: en-US
---

# This is an title

## This is an slide

Hello `"world"`{.rust} bla-bla

```rust
fn main() {
	println!("Hello, world: {}", 1 != 2);
	// |--->-------!--------||-----!!---|
}
```

::: notes

These are some-notes

:::


## Next slide

Much content

## Set code title

```{=latex}
\tcbset{title=My Title}
```

```haskell
main :: IO ()
main = print . md5 . pack . unwords =<< getArgs
  where
    md5 x = hash x :: Digest MD5
```

```{=latex}
\tcbset{title=}
```

## Blocks

### Block

This is an block

### Example {.example}

$$\sum_{x=1}^{42}\dfrac{3^x}{!4}$$

### Alert {.alert}

This is an alert

# This is another title

## Again

???
