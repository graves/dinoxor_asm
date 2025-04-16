# Dinoxor ASM


```
                          _._
                        _/:|:
                       /||||||.
                       ||||||||.
                      /|||||||||:
                     /|||||||||||
                    .|||||||||||||
                    | ||||||||||||:
                  _/| |||||||||||||:_=---.._
                  | | |||||:'''':||  '~-._  '-.
                _/| | ||'         '-._   _:    ;
                | | | '               '~~     _;
                | '                _.=._    _-~
             _.~                  {     '-_'
     _.--=.-~       _.._          {_       }
 _.-~   @-,        {    '-._     _. '~==+  |
('          }       \_      \_.=~       |  |
`======='  /_         ~-_    )         <_oo_>
  `-----~~/ /'===...===' +   /
         <_oo_>         /  //
                       /  // 
                      <_oo_>
```

I needed a good enough reason to finally [learn how to do inline assembly in Rust](https:github.com/graves/thechinesegovernment). I thought this might be an interesting way to use generative testing tools like [quickcheck](https://github.com/BurntSushi/quickcheck). I needed to first make sure the logic worked in raw assembly.

- [dinoxor.s](./dinoxor.s) contains the dinoxor assembly code.
- [main.c](./main.c) contains a simple C program for using the `dinoxor` proccedure to XOR a byte against another byte.
- [rc4.c](./rc4.c) contains simple RC4 encryption and decryption routines that utilize the `dinoxor` procedure.

# How to build

There's a [Makefile](./Makefile) that will build both binaries with:

```sh
make clean
make all
```

# How to run

```sh
λ ./dinoxor_exe
0b11111111

λ ./rc4_exe
Ciphertext: BBF316E8D940AF0AD3
Decrypted Text: Plaintext
```

# What in the world is going on here?

I wrote a pretty comprehensive blog post on [re-implementing bitwise operations as abstractions in aarch64 neon registers](https://awfulsec.com/dinoxor.html), that explains how the logic works.