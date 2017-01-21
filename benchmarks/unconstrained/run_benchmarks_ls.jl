using Optim, OptimTests, CUTEst, ProgressMeter, Plots, DataFrames, BenchmarkTools
using LineSearches

do_benchmarks = true
saveplots = true

current_dir = pwd()
pkg_dir = Pkg.dir("OptimTests")
version_sha = latest_commit("OptimTests")
benchmark_dir = pkg_dir*"/benchmarks/unconstrained/history/"
version_dir = benchmark_dir*version_sha
try
    run(`mkdir $version_dir`)
catch

end
cd(version_dir)

default_names = ["Hager-Zhang",
                 "BT3",
                 "BT2",
                 "More-Thuente",
                 "Wolfe",
                 "Basic"
                 ]

default_solvers =[Newton(linesearch=LineSearches.hagerzhang!),
                  Newton(linesearch=LineSearches.bt3!),
                  Newton(linesearch=LineSearches.bt2!),
                  Newton(linesearch=LineSearches.morethuente!),
                  Newton(linesearch=LineSearches.strongwolfe!),
                  Newton(linesearch=LineSearches.basic!),
                  ]

do_benchmarks && include("default/optim_benchmarks.jl")
saveplots && save_plots(version_dir, :optim)

do_benchmarks && include("default/cutest_benchmarks.jl")
saveplots && save_plots(version_dir, :cutest)

cd(current_dir)
