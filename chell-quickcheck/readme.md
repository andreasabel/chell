QuickCheck support for the [Chell] testing library.

  [Chell]: https://hackage.haskell.org/package/chell

```haskell
import Test.Chell
import Test.Chell.QuickCheck

tests :: Suite
tests =
  suite "tests"
      [ test_Equality
      , test_Increment
      ]

test_Equality :: Test
test_Equality = property "equality" (\x -> x == x)

test_Increment :: Test
test_Increment = property "equality" (\x -> x + 1 > x)

main :: IO ()
main = defaultMain [tests]
```
