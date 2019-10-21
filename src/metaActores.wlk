import wollok.game.*
import actores.*
import clasesBase.*

object spawner {

	method spawnearTronco(posicionInicial, velocidadTronco, direccionTronco) {
		const imagenPrimerTronco = "tronco/" + direccionTronco.nombre() + ".png"
		const imagenUltimoTronco = "tronco/" + direccionTronco.opuesto().nombre() + ".png"
		const tercerTronco = new Tronco(image = imagenUltimoTronco, position = direccionTronco.posicionADistanciaDirecta(posicionInicial, -2), velocidad = 0, direccion = direccionTronco, proximoTronco = troncoNulo)
		const segundoTronco = new Tronco(image = "tronco/body.png", position = direccionTronco.posicionADistanciaDirecta(posicionInicial, -1), velocidad = 0, direccion = direccionTronco, proximoTronco = tercerTronco)
		const primerTronco = new Tronco(image = imagenPrimerTronco, position = posicionInicial, velocidad = velocidadTronco, direccion = direccionTronco, proximoTronco = segundoTronco)
		[ tercerTronco, segundoTronco, primerTronco ].forEach({ tronco => game.addVisual(tronco)})
		primerTronco.empezarMovimientoConstante()
	}

	method spawnearFilaDeTroncos(cantidadTroncos, fila, velocidadTroncos, direccionTroncos, distanciaEntreTroncos) {
		var ultimaPosicionDeTronco = game.at(0, fila)
		cantidadTroncos.times({ _ =>
			self.spawnearTronco(ultimaPosicionDeTronco, velocidadTroncos, direccionTroncos)
			ultimaPosicionDeTronco = ultimaPosicionDeTronco.right(distanciaEntreTroncos)
		})
	}

	method spawnearFilaDeAutos(cantidadAutos, fila, velocidadAutos, direccionAutos, distanciaEntreAutos) { // TODO: Los autos se desincronizan, tal vez se puede hacer como los troncos? Eso tal vez haria necesaria la clase de seguidor o algo
		var ultimaPosicionDeAuto = game.at(0, fila)
		const autos = []
		const numeroRandomDeSpriteAuto = [ 1, 2, 3, 4 ].anyOne().toString()
		const spriteAuto = "autos/auto" + numeroRandomDeSpriteAuto + "/" + direccionAutos.nombre() + ".png"
		cantidadAutos.times({ _ =>
			autos.add(new Obstaculo(image = spriteAuto, position = ultimaPosicionDeAuto, velocidad = velocidadAutos, direccion = direccionAutos))
			ultimaPosicionDeAuto = ultimaPosicionDeAuto.right(distanciaEntreAutos)
		})
		autos.forEach({ auto =>
			game.addVisual(auto)
			auto.empezarMovimientoConstante()
		})
	}

	method spawnearAgua() {
		const filas = 8 .. 13
		const columnas = 0 .. 14
		filas.forEach({ fila => columnas.forEach({ columna => game.addVisual(new Agua(position = game.at(columna, fila)))})})
	}

	method spawnearMetas() {
		const columnas = [ 2, 5, 8, 11 ]
		const fila = 13
		columnas.forEach({ columna => game.addVisual(new Meta(position = game.at(columna, fila)))})
	}

	method spawnearEscenciales() {
		self.spawnearAgua()
		self.spawnearMetas()
	}

}

object worldManager {

	method inicializarMundo() {
		spawner.spawnearEscenciales()
		spawner.spawnearFilaDeTroncos(1, 8, 300, izquierda, 0)
		spawner.spawnearFilaDeTroncos(3, 9, 100, derecha, 6)
		spawner.spawnearFilaDeTroncos(2, 10, 400, izquierda, 12)
		spawner.spawnearFilaDeTroncos(1, 11, 500, derecha, 0)
		spawner.spawnearFilaDeTroncos(1, 12, 600, izquierda, 0)
		spawner.spawnearFilaDeAutos(1, 3, 100, derecha, 4)
		const rana2P = new Rana(nombreSprite = "rana2P", posicionInicial = game.at(11, 1), position = game.at(11, 1), otraRana = null) // TODO: Medio HORRIBLE
		const rana1P = new Rana(nombreSprite = "rana", otraRana = rana2P)
		rana2P.otraRana(rana1P)
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
		keyboard.backspace().onPressDo({self.reiniciarMundo()}) //The secret key
	}
	
	
	method reiniciarMundo(){
		game.clear()
		self.inicializarMundo()
	}

}
