newton epsilon f f' guess = let newGuess = guess - (f guess / f' guess)
                                    err  = abs (newGuess - guess)
                            in if (err < epsilon)
                                then newGuess
                                else newton epsilon f f' newGuess

