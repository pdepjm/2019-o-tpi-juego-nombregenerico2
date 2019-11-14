import wollok.game.*
import actores.*
import clasesBase.*
import victoria.*

object coordinadorDeMovimiento{
	var todosLosMovibles = []
	var frameActual = 1
	
	method adelantarFrame(){
		const frameMaximo = 2520 //MCM del 1..10
		if (frameActual + 1 == frameMaximo){
			frameActual = 1
		}
		else{
			frameActual++
		}
	}
	
	method intentarMoverMovible(unMovible) {
		if(unMovible.estaEnFrameDeMovimiento(frameActual)){
			unMovible.moverse()
		}
	}
	
	method inicializarTodosLosMovimientos(){
		todosLosMovibles.forEach({unMovible => game.addVisual(unMovible)})
		game.onTick(100,"pusher",
			{
				todosLosMovibles.forEach({unMovible => 
					self.intentarMoverMovible(unMovible)})
			self.adelantarFrame()
		})
	}
	
	method agregarListaDeMovibles(movibles){
		todosLosMovibles += movibles
	}
	
	method liberarMovibles(){
		todosLosMovibles.clear()
	}

	
}

object spawner {

	method spawnearTronco(posicionInicial, velocidadTronco, direccionTronco) { //Velocidad es un numero del 10 al 1 de que tan rapido va
		const imagenPrimerTronco = "tronco/" + direccionTronco.nombre() + ".png"
		const imagenUltimoTronco = "tronco/" + direccionTronco.opuesto().nombre() + ".png"
		const tercerTronco = new Montable(image = imagenUltimoTronco, position = direccionTronco.posicionADistanciaDirecta(posicionInicial, -2),frameDeMovimiento = velocidadTronco, direccion = direccionTronco)
		const segundoTronco = new Montable(image = "tronco/body.png", position = direccionTronco.posicionADistanciaDirecta(posicionInicial, -1),frameDeMovimiento = velocidadTronco, direccion = direccionTronco)
		const primerTronco = new Montable(image = imagenPrimerTronco, position = posicionInicial, direccion = direccionTronco,frameDeMovimiento = velocidadTronco)
		return [primerTronco,segundoTronco,tercerTronco]
	}

	method spawnearFilaDeTroncos(cantidadTroncos, fila, velocidadTroncos, direccionTroncos, distanciaEntreTroncos) {
		var ultimaPosicionDeTronco = game.at(0, fila)
		var listaDeTroncos = []
		cantidadTroncos.times({ _ =>
			listaDeTroncos.add(self.spawnearTronco(ultimaPosicionDeTronco, velocidadTroncos, direccionTroncos))
			ultimaPosicionDeTronco = ultimaPosicionDeTronco.right(distanciaEntreTroncos)
		})
		listaDeTroncos = listaDeTroncos.flatten()
		coordinadorDeMovimiento.agregarListaDeMovibles(listaDeTroncos)
		
		
	}

	method spawnearFilaDeAutos(cantidadAutos, fila, velocidadAutos, direccionAutos, distanciaEntreAutos) { 
		var ultimaPosicionDeAuto = game.at(0, fila)
		const autos = []
		const numeroRandomDeSpriteAuto = [ 1, 2, 3, 4 ].anyOne().toString()
		const spriteAuto = "autos/auto" + numeroRandomDeSpriteAuto + "/" + direccionAutos.nombre() + ".png"
		cantidadAutos.times({ _ =>
			autos.add(new Obstaculo(image = spriteAuto, position = ultimaPosicionDeAuto, direccion = direccionAutos, frameDeMovimiento = velocidadAutos))
			ultimaPosicionDeAuto = ultimaPosicionDeAuto.right(distanciaEntreAutos)
		})
		coordinadorDeMovimiento.agregarListaDeMovibles(autos)
	}

	method spawnearAgua() {
		const filas = 8 .. 13
		const columnas = 0 .. 14
		filas.forEach({ fila => columnas.forEach({ columna => game.addVisual(new Agua(position = game.at(columna, fila)))})})
	}

	method spawnearMetas() {
		const columnas = [ 2, 5, 8, 11 ]
		const fila = 2
		columnas.forEach({ columna => game.addVisual(new Meta(position = game.at(columna, fila)))})
	}

	method spawnearBarrerasLimite() {
		const filas = 0 .. 14
		const columnas = -1 .. 15
		filas.forEach({ fila =>
			game.addVisual(new BarreraLimite(position = game.at(-1, fila)))
			game.addVisual(new BarreraLimite(position = game.at(14, fila)))
		})
		columnas.forEach({ columna => game.addVisual(new BarreraLimite(position = game.at(columna, 0)))})
	}

	method spawnearEscenciales() {
		self.spawnearAgua()
		self.spawnearMetas()
		self.spawnearBarrerasLimite()
	}

}

class RanaVictoriosa {

	const property position
	const property image

}

object fondoVictoriaTemporal {

	const property position = game.at(0, 0)
	const property image = "base de ganar.png"

}

object generadorDelMundo {

	method inicializarMundo() {
		spawner.spawnearEscenciales()
		spawner.spawnearFilaDeTroncos(1, 8, 3, izquierda, 0)
		spawner.spawnearFilaDeTroncos(3, 9, 1, derecha, 6)
		spawner.spawnearFilaDeTroncos(2, 10, 4, izquierda, 12)
		spawner.spawnearFilaDeTroncos(1, 11, 5, derecha, 0)
		spawner.spawnearFilaDeTroncos(1, 12, 6, izquierda, 0)
		spawner.spawnearFilaDeAutos(3, 3, 1, derecha, 4)
		spawner.spawnearFilaDeAutos(2, 5, 3, izquierda, 2)
		spawner.spawnearFilaDeAutos(1, 4, 5, izquierda, 2)
		coordinadorDeMovimiento.inicializarTodosLosMovimientos()
		const rana1P = new Rana(nombreSprite = "rana", image = "rana/up.png", representacionVidas = new RepresentacionDeVidas(posicionBase = game.at(0,0),direccionVidas = derecha))
		const rana2P = new Rana(nombreSprite = "rana2P", posicionInicial = game.at(11, 1), position = game.at(11, 1), image = "rana2P/up.png", representacionVidas = new RepresentacionDeVidas(posicionBase = game.at(13,0),direccionVidas = izquierda))
		rana1P.inicializarRepresentacionDeVidas()
		rana2P.inicializarRepresentacionDeVidas()
		controladorDeVictorias.agregarRana(rana2P)
		controladorDeVictorias.agregarRana(rana1P)
		game.addVisual(rana1P)
		game.addVisual(rana2P)
		game.onCollideDo(rana2P, { colisionador => colisionador.colisionarConUnaRana(rana2P)})
		game.onCollideDo(rana1P, { colisionador => colisionador.colisionarConUnaRana(rana1P)})
		keyboard.up().onPressDo({ rana1P.tratarDeMoverseEnDireccion(arriba)})
		keyboard.down().onPressDo({ rana1P.tratarDeMoverseEnDireccion(abajo)})
		keyboard.right().onPressDo({ rana1P.tratarDeMoverseEnDireccion(derecha)})
		keyboard.left().onPressDo({ rana1P.tratarDeMoverseEnDireccion(izquierda)})
		keyboard.w().onPressDo({ rana2P.tratarDeMoverseEnDireccion(arriba)})
		keyboard.s().onPressDo({ rana2P.tratarDeMoverseEnDireccion(abajo)})
		keyboard.d().onPressDo({ rana2P.tratarDeMoverseEnDireccion(derecha)})
		keyboard.a().onPressDo({ rana2P.tratarDeMoverseEnDireccion(izquierda)})
		keyboard.backspace().onPressDo({ self.animacionVictoria(rana1P)}) // The secret key
		
	}

	method reiniciarMundo() {
		coordinadorDeMovimiento.liberarMovibles()
		game.clear()
		self.inicializarMundo()
	}

	method animacionVictoria(ranaGanadora) {
		game.clear()
		game.addVisual(fondoVictoriaTemporal)
		const spriteGanador = ranaGanadora.spriteMeta()
		game.schedule(10000, { game.addVisual(new RanaVictoriosa(position = game.center(), image = spriteGanador))})
		game.schedule(13000, { game.onTick(10, "magia random", { game.addVisual(new RanaVictoriosa(image = spriteGanador, position = game.at(0.randomUpTo(14), 0.randomUpTo(16))))})})
		game.schedule(14500, { self.reiniciarMundo()})
	}

}

