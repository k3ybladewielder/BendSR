# Apps

Graphics in Bend are pure: a frame is an `Image`; `App` maps states to images.

```python
import Base

# tick: folds a frame's events into the next state; None quits the app
def tick(events: List<Event>, color: U32) -> IO(Maybe<U32>):
  match events:
    case Nil{}:
      IO.pure(Maybe<U32>, Some{color})
    case Con{Close{}, rest}:
      IO.pure(Maybe<U32>, None{})
    case Con{e, rest}:
      tick(rest, (color + 1 : U32))

def main() -> IO(Unit):
  # view: returns the state beside its image; Pix paints the whole frame
  App.run(~U32, ~App{+s => (s, Pix{s}), tick}, "Hello", 256, 256, 0)
```

An `Image` is a quadtree: `Pix{color}` paints a square, and `Qua{tl, tr, bl,
br}` splits it in four, so a frame is drawn by recursion like everything else,
in parallel if you want. Events are `Key`, `Mouse`, `Move` and `Close`.
`App.run` opens a window and calls `view` then `tick` once per frame, until
`tick` answers `None`. Since the state is affine, `view` must hand it back next
to the image. Underneath are `Window.open`, `Window.frame` and `Window.close`,
and `Audio.open`, `Audio.write` and `Audio.close` for sound. See
`demos/app_pong_game_2d` for a complete one.
