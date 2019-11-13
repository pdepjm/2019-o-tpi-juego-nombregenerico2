import clasesBase.*
import wollok.game.*
import metaActores.*

class Rana {

	
	var property position = game.at(2, 1)
	var property vidas = 3
	var property puntos = 0
	const property posicionInicial = game.at(2, 1)
	const property nombreSprite
	var property image

	method empujarATodosEnUnaPosicion(posicion,direccionEnLaQueEmpujar){
		game.getObjectsIn(posicion).forEach({unElemento => unElemento.empujarse(direccionEnLaQueEmpujar)})
	}
	
	method posicionEsAtravesable(posicion) = (game.getObjectsIn(posicion)).all({unElemento => unElemento.esAtravesable()})

	method tratarDeMoverseEnDireccion(direccionAMoverse) {
		self.cambiarImagenSegunDireccion(direccionAMoverse)
		const posicionADondeMoverse = direccionAMoverse.proximaPosicionDirecta(position)
		self.empujarATodosEnUnaPosicion(posicionADondeMoverse,direccionAMoverse)
		if(self.posicionEsAtravesable(posicionADondeMoverse)){
			position = posicionADondeMoverse
		}
		
	}

	method cambiarPosicionForzado(posicion) { // TODO: cambiar nombre
			position = posicion
	}

	method volverAlInicio() {
		self.cambiarImagenSegunDireccion(arriba)
		position = posicionInicial
	}

	method morir() {
		if (vidas != 0) {
			vidas--
				// TODO: Aca hacer la animacion de la muerte
			self.volverAlInicio()
		} else {
			self.morirDefinitivo()
		}
	}
	
	method morirDefinitivo(){
		controladorDeVictorias.checkearVictoria()
		image = "tronco/body.png"
	}
	
	method estaViva() = vidas > 0

	method ganar() {
		puntos++
		controladorDeVictorias.checkearVictoria()
		self.volverAlInicio()
	}

	/*TODO: Tiene que haber una contador visual de vidas, entonces tiene que haber un objeto que minimamente
	 * represente visualmente las vidas. Pero si vamos a hacer un objeto de vidas, no tendriamos
	 * que hacer ese objeto maneje las vidas en vez de la rana? Para pensar.
	 */
	method colisionarConUnaRana(unaRana) {
		game.sound("croak.mp3")
	}

	method empujarse(direccionEnLaQueEmpujar) {
		self.tratarDeMoverseEnDireccion(direccionEnLaQueEmpujar)
	}
	
	method ganarDefinitivo(){
		generadorDelMundo.reiniciarMundo()
	}
	
	method esAtravesable() = false

	method spriteMeta() = nombreSprite + "/bigBoy.png"
	
	method cambiarImagenSegunDireccion(direccion){
		image = nombreSprite + "/" + direccion.nombre() + ".png"
	}
}

class Tronco inherits Montable {

	const proximoTronco

	override method moverse() {
		super()
		proximoTronco.moverse()
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
	method empujarse(_){
		
	}
	method esAtravesable() = true

}

object metaLibre{
	method actuarPorRanaEnMeta(meta,unaRana){
		unaRana.ganar()
		controladorDeVictorias.checkearVictoria()
		meta.ocuparsePorRana(unaRana)
	}
}
object metaOcupada{
	method actuarPorRanaEnMeta(_,unaRana){
		unaRana.morir()
	}
	
}

class Meta {

	const property position
	var property image = "nada.png"
	var estadoOcupado = metaLibre

	method colisionarConUnaRana(unaRana) {
		estadoOcupado.actuarPorRanaEnMeta(self,unaRana)
	}

	method ocuparsePorRana(unaRana){
		image = unaRana.spriteMeta()
		estadoOcupado = metaOcupada
	}
	
	method esAtravesable() = true
	method empujarse(_){
		
	}
	

}

class BarreraLimite{
	const property position
	const property image = "nada.png"
	
	method esAtravesable() = false
	method empujarse(_){
		
	}
}

object troncoNulo {

	method moverse() {
	}

}

