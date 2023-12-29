using Symbolics, Latexify


function doit(iters::Int)
	@variables x y w

	z = (x-1) * y^2 + (y-2) * w^2 + (w-3) * x^2 

	myio = open("/home/hako/Desktop/latex/newton4.tex", "w")

	grad = Symbolics.gradient(z, [x, y, w])
	hess = Symbolics.hessian(z, [x, y, w])

	println(myio, "\\documentclass{article}")
	println(myio, "\\usepackage{geometry}")
	println(myio, "\\geometry{margin=1.5cm}")

	println(myio, "\\begin{document}")

	println(myio, "\\subsubsection{Initials}")
	println(myio, "Function:")
	println(myio, latexify(z))
	println(myio, "Gradient Vector:")
	println(myio, latexify(grad))
	println(myio, "Hession Matrix:")
	println(myio, latexify(hess))

	xval = 1.0
	yval = 0.0
	wval = 1.0

	valdict = Dict(x => xval, y => yval, w => wval)
	println(myio, "Start Value:")
	println(myio, valdict |> Tuple)
    
    println(myio, "Function at point:")
    myf = substitute(z, valdict)
    println(myio, myf)

	for i in 1:iters
		println(myio, "\\subsubsection{Iteration $i}")
		println(myio, "Gradient at $(valdict |> Tuple)")
		mygrad = substitute(grad, valdict)
		println(myio, latexify(mygrad))

		println(myio, "Hessian at $(valdict |> Tuple)")
		myhess = substitute(hess, valdict)
		println(myio, latexify(myhess))

		println(myio, "Inverse of Hessian")
		invhess = inv(myhess)
		println(myio, latexify(invhess))

		myresult = [xval, yval, wval] - invhess * mygrad
		xval = myresult[1]
		yval = myresult[2]
		wval = myresult[3]
		valdict = Dict(x => xval, y => yval, w => wval)
		println(myio, valdict |> Tuple)

        println(myio, "Function at point:")
        mynewf = substitute(z, valdict)
        println(myio, latexify(mynewf))

        println(myio, "Diff of function values between two iterations:")
        println(myio, latexify(abs(mynewf - myf)))
        myf = mynewf
	end


	println(myio, "\\end{document}")
	close(myio)

end

doit(10)

