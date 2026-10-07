almacenar(N, [N]):- N >= 0,
    N < 10.

almacenar(N, [D|C]):- N >= 10,
    D is N mod 10,
    R is N // 10,
    almacenar(R, C).