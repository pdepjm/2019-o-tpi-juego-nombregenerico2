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
	
	method spawnearBarrerasLimite(){
		const filas = 0 .. 14
		const columnas = -1 .. 15
		
		filas.forEach({fila => 
			game.addVisual(new BarreraLimite(position = game.at(-1,fila)))
			game.addVisual(new BarreraLimite(position = game.at(14,fila)))
			})
		
		columnas.forEach({columna => game.addVisual(new BarreraLimite(position = game.at(columna,0)))})
	
		
	}

	method spawnearEscenciales() {
		self.spawnearAgua()
		self.spawnearMetas()
		self.spawnearBarrerasLimite()
	}

}

object generadorDelMundo {

	method inicializarMundo() {
		spawner.spawnearEscenciales()
		spawner.spawnearFilaDeTroncos(1, 8, 300, izquierda, 0)
		spawner.spawnearFilaDeTroncos(3, 9, 100, derecha, 6)
		spawner.spawnearFilaDeTroncos(2, 10, 400, izquierda, 12)
		spawner.spawnearFilaDeTroncos(1, 11, 500, derecha, 0)
		spawner.spawnearFilaDeTroncos(1, 12, 600, izquierda, 0)
		spawner.spawnearFilaDeAutos(3, 3, 100, derecha, 4)
		spawner.spawnearFilaDeAutos(2, 5, 300, izquierda, 2)
		spawner.spawnearFilaDeAutos(1, 4, 50, izquierda, 2)
		const rana1P = new Rana(nombreSprite = "rana",image = "rana/up.png")
		const rana2P = new Rana(nombreSprite = "rana2P", posicionInicial = game.at(11, 1), position = game.at(11, 1),image = "rana2P/up.png")
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
		keyboard.backspace().onPressDo({ self.reiniciarMundo()}) // The secret key
		
	}

	method reiniciarMundo() {
		game.clear()
		self.inicializarMundo()
	}

}

object victoriaEstandar{ // Hay victoria si hay una rana con suficientes puntos para ganar directo
	method hayVictoria(){
		return controladorDeVictorias.algunaRanaGano()
	}
}

object victoriaPorPuntosRestantes{ // Si no quedan ranas vivas, hay alguna victoria (asumiendo que no hay empate)
	method hayVictoria(){
		return controladorDeVictorias.ranasVivas().size() == 0
	}
}


object victoriaPorDefault{ // Si queda una rana viva y tiene mas puntos que la(s) muerta(s), hay victoria.
	method hayVictoria(){
		const ranasVivas = controladorDeVictorias.ranasVivas()
		if (ranasVivas.size() == 1){
			const unicaRanaViva = ranasVivas.anyOne()
			return unicaRanaViva == controladorDeVictorias.ranaPuntera() // Si la rana es puntera, hay victoria. Si no, no deberia parar el juego.
		}
		else{
			return false
		}
	}
}

object controladorDeVictorias {

	const ranas = []
	
	const puntosNecesariosParaGanar= 3
	
	method ranaEsGanadoraDefinitiva(unaRana) = unaRana.puntos() >= puntosNecesariosParaGanar
	
	method ranaPuntera() = ranas.max({unaRana => unaRana.puntos()}) // Se asume que no hay empate
	
	method algunaRanaGano() = ranas.any({unaRana => self.ranaEsGanadoraDefinitiva(unaRana)})

	method puntosDeRanas() = ranas.map({ unaRana => unaRana.puntos() })
	
	method vanEmpatando() {
		const puntosMaximos = self.puntosDeRanas().max()
		return self.puntosDeRanas().occurrencesOf(puntosMaximos) > 1 //Osea si la cantidad maxima de puntos aparece mas de 1 vez, es que hay 2 ranas empatando
		//Igualmente no es como que si alguna vez van a haber mas de 2 ranas pero ok.
	}

	method ranasVivas() = ranas.filter({ unaRana => unaRana.estaViva()})

	method hayAlgunaVictoria(){
		
		if(!self.vanEmpatando()){
		const metodosDeVictoria = [victoriaEstandar,victoriaPorDefault,victoriaPorPuntosRestantes]
		return metodosDeVictoria.any({unMetodo => unMetodo.hayVictoria()})
		}
		else{
			return false
		}

	}

	method checkearVictoria() { 
		if(self.hayAlgunaVictoria()){
			self.victoriaParaRanaPuntera()
		}
	}
	
	method victoriaParaRanaPuntera() {
		self.ranaPuntera().ganarDefinitivo()
		ranas.clear()
	}

	method agregarRana(unaRana) {
		ranas.add(unaRana)
	}

}

