import clasesBase.*
import wollok.game.*
import victoria.*
import constructores.*

class Rana {

	var property position = game.at(2, 1)
	var property vidas = 3
	var property puntos = 0
	const property posicionInicial = game.at(2, 1)
	const property nombreSprite
	var property image
	const representacionVidas
	var property esAtravesable = false

	method empujarATodosEnUnaPosicion(posicion, direccionEnLaQueEmpujar) {
		game.getObjectsIn(posicion).forEach({ unElemento => unElemento.empujarse(direccionEnLaQueEmpujar)})
	}

	method posicionEsAtravesable(posicion) = (game.getObjectsIn(posicion)).all({ unElemento => unElemento.esAtravesable() })

	method tratarDeMoverseEnDireccion(direccionAMoverse) {
		if (self.estaViva()) {
			self.cambiarImagenSegunDireccion(direccionAMoverse)
			const posicionADondeMoverse = direccionAMoverse.proximaPosicionDirecta(position)
			self.empujarATodosEnUnaPosicion(posicionADondeMoverse, direccionAMoverse)
			if (self.posicionEsAtravesable(posicionADondeMoverse)) {
				position = posicionADondeMoverse
			}
		}
	}

	method cambiarPosicionForzado(posicion) {
		if (self.estaViva()){
			position = posicion	
		}
		
	}

	method volverAlInicio() {
		self.cambiarImagenSegunDireccion(arriba)
		position = posicionInicial
	}

	method morir() {
		vidas -= 1
		if (vidas > 0) {
			representacionVidas.perderVida()
			self.volverAlInicio()
		} else if (vidas == 0){
			self.morirDefinitivo()
		}
	}

	method morirDefinitivo() {
		controladorDeVictorias.checkearVictoria()
		image = "skull.png"
		esAtravesable = true
	}

	method estaViva() = vidas > 0

	method ganar() {
		puntos += 1
		controladorDeVictorias.checkearVictoria()
		self.volverAlInicio()
	}
	
	method colisionarConUnaRana(unaRana) {
		game.sound("croak.mp3")
	}

	method empujarse(direccionEnLaQueEmpujar) {
		self.tratarDeMoverseEnDireccion(direccionEnLaQueEmpujar)
	}

	method ganarDefinitivo() {
		generadorDelMundo.animacionVictoria(self)
	}

	method spriteMeta() = nombreSprite + "/bigBoy.png"

	method cambiarImagenSegunDireccion(direccion) {
		image = nombreSprite + "/" + direccion.nombre() + ".png"
	}
	
	method inicializarRepresentacionDeVidas(){
		representacionVidas.incializarVidas(nombreSprite + "/smolBoi.png",vidas)
	}

}

class Vida{
	const property position
	const property image
}

class RepresentacionDeVidas{
	const posicionBase
	const direccionVidas
	const vidas = []
	
	method incializarVidas(spriteVidas,cantidadVidas){
		(2..cantidadVidas).forEach({numeroVida => vidas.add(new Vida(position = direccionVidas.posicionADistanciaDirecta(posicionBase,numeroVida-2),image = spriteVidas))})
		vidas.forEach({unaVida => game.addVisual(unaVida)})
	}
	
	method perderVida(){
		const vidaARemover = vidas.last()
		game.removeVisual(vidaARemover)
		vidas.remove(vidaARemover)
	}
}


class Agua {

	const property position
	const property image = "nada.png"

	method colisionarConUnaRana(unaRana) {
		if (game.getObjectsIn(position).size() == 2) { // Si hay mas de 2 cosas es que hay un tronco :)
			unaRana.morir()
		}
	}

	method empujarse(_) {
	}

	method esAtravesable() = true

}

object metaLibre {

	method actuarPorRanaEnMeta(meta, unaRana) {
		unaRana.ganar()
		meta.ocuparsePorRana(unaRana)
	}

}

object metaOcupada {

	method actuarPorRanaEnMeta(_, unaRana) {
		unaRana.morir()
	}

}

class Meta {

	const property position
	var property image = "nada.png"
	var estadoOcupado = metaLibre

	method colisionarConUnaRana(unaRana) {
		estadoOcupado.actuarPorRanaEnMeta(self, unaRana)
	}

	method ocuparsePorRana(unaRana) {
		image = unaRana.spriteMeta()
		estadoOcupado = metaOcupada
	}

	method esAtravesable() = true

	method empujarse(_) {
	}

}

class BarreraLimite {

	const property position
	const property image = "nada.png"

	method colisionarConUnaRana(unaRana) {
		unaRana.morir()
	}

	method esAtravesable() = false

	method empujarse(_) {
	}

}

object troncoNulo {

	method moverse() {
	}

}

class Tronco inherits Montable {

	const proximoTronco

	override method moverse() {
		super()
		proximoTronco.moverse()
	}

}

