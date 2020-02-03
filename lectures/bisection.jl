function bisection(f, a, b, ϵ=1e-10)
    if sign(f(a)) == sign(f(b))
        error("Bisection requires opposite signs")
    end

    m = 0.5 * (a + b)

    while abs(a - b) > ϵ

        m = 0.5 * (a + b)

        if f(m) == 0
            return m
        end

        if sign(f(m)) == sign(f(a))
            a = m
        else
            b = m
        end

    end

    return m
end

s = bisection(x->x^2 - 2, 1, 2)

sqrt(2)

abs(s - sqrt(2))
