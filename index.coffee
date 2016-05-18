canvas = document.querySelector 'canvas'
ctx = canvas.getContext '2d'

runSimulation = (opts) ->
  if opts.timeStep is 0
    return

  t = opts.timeStart
  x = opts.initialX
  v = opts.initialV

  history = []
  until t >= opts.timeEnd
    t += opts.timeStep

    springForce = -x * opts.springConstant
    constantForce = opts.constantForce
    dampingForce = -v * opts.dampingConstant
    drivingForce = opts.drivingForce * Math.sin(t * opts.drivingFrequency)

    netForce = springForce + constantForce + dampingForce + drivingForce

    v += (netForce / opts.mass) * opts.timeStep
    x += v * opts.timeStep

    history.push {
      t, x, v
    }
  return history

map = (value, from, to) -> ((value - from[0]) / (from[1] - from[0])) * (to[1] - to[0]) + to[0]

plotSimulation = (history) ->
  ctx.clearRect 0, 0, canvas.width, canvas.height

  trange = [
    Math.min.apply(@, history.map((x) -> x.t)),
    Math.max.apply(@, history.map((x) -> x.t))
  ]
  xrange = [
    Math.min.apply(@, history.map((x) -> x.x)),
    Math.max.apply(@, history.map((x) -> x.x))
  ]
  vrange = [
    Math.min.apply(@, history.map((x) -> x.v)),
    Math.max.apply(@, history.map((x) -> x.v))
  ]

  canvasHeight = [0, canvas.height]
  canvasWidth = [0, canvas.width]

  ctx.beginPath()
  ctx.moveTo map(history[0].t, trange, canvasWidth), map(history[0].x, xrange, canvasHeight)

  for element in history
    ctx.lineTo map(element.t, trange, canvasWidth), map(element.x, xrange, canvasHeight)

  ctx.strokeStyle = '#00F'
  ctx.stroke()

options = {
  timeStart: 'time-start'
  springConstant: 'spring-constant'
  constantForce: 'constant-force'
  dampingConstant: 'damping-constant'
  drivingForce: 'driving-force'
  drivingFrequency: 'driving-frequency'
  mass: 'mass'

  timeStart: 'time-start'
  timeEnd: 'time-end'
  timeStep: 'time-step'
  initialX: 'initial-x'
  initialV: 'initial-v'
}

redraw = ->
    opts = {}
    for key, val of options
      opts[key] = Number val.value
      if isNaN opts[key]
        return

    plotSimulation runSimulation opts

for key, val of options
  options[key] = document.getElementById val

  options[key].addEventListener 'input', redraw

do redraw
