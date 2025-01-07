# chell

A quiet test runner for Haskell

## Building

To build and test with all supported compiler versions:

    nix build .#testConfigurations.all --no-link

## History

Back in 2011 or so, the most popular Haskell test frameworks generated a lot of status output but relatively little info about why tests failed. John Millikin wrote Chell so that tests would be quiet if they passed, and give to-the-line error info on failure.

It hasn't seen much development effort the past few years. As of February 2019, Chris and Julie are keeping it compiling.

## Assertions

Chell has a small selection of built-in assertions, which cover most simple testing requirements. Use the `$assert` or `$expect` functions to run assertions. See the [Chell API documentation](https://hackage.haskell.org/package/chell/docs/Test-Chell.html) for full type signatures.

```haskell
{-# LANGUAGE TemplateHaskell #-}

import Test.Chell

tests :: Suite
tests =
    suite "tests"
        [ test_Numbers
        , test_Text
        ]

test_Numbers :: Test
test_Numbers =
    assertions "numbers" $
      do
        $assert (equal 1 1)
        $assert (greater 2 1)
        $assert (equalWithin 1.0001 1.0 0.01)

test_Text :: Test
test_Text =
    assertions "text" $
      do
        let
            str1 = "foo\nbar\nbaz"
            str2 = "foo\nbar\nqux"

	      $assert (equalLines str1 str2)

main :: IO ()
main = defaultMain [tests]
```

## QuickCheck

Chell also supports running QuickCheck properties, via the [chell-quickcheck](https://hackage.haskell.org/package/chell-quickcheck/docs/Test-Chell-QuickCheck.html) package.

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
