//INTENSAMENTE//

class Persona {
  const property emociones = []
  var property intensidad
  var property edad

  //PUNTO 1//
  method esAdolescente() = edad.between(12, 19)

  //PUNTO 2//
  method nuevaEmocion(unaEmocion) {
    emociones.add(unaEmocion)
  }

  //PUNTO 3//
  method estaPorExplotar() = emociones.all({ e => e.puedeLiberarse() })

  //PUNTO 4//
  method vivirEvento(unEvento) {
    unEvento.liberarEmociones(emociones)
  }
}

class Grupo {
  const property grupoPersonas = []

  method agregarPersona(unaPersona) {
    grupoPersonas.add(unaPersona)
  }

  //PUNTO 4//
  method vivirEvento(unEvento) {
    grupoPersonas.forEach({ p => p.vivirEvento(unEvento) })
  }
}

class Evento {
  var property impacto
  const property descripcionEvento

  method liberarEmociones(variasEmociones) {
    variasEmociones.forEach({ e => e.liberar(self) })
  }

  //PUNTO 6//
  method vivirEvento(unAlgo) { //SE PODRÍA LLAMAR SUCEDER//
    unAlgo.vivirEvento(self)
  }
}

class Emocion {
  var property intensidad = 0
  var property intensidadLimite = 120 //INVENTADO//
  var property eventosVividos = []

  method cantidadEventosVividos() = eventosVividos.size()

  //PUNTO 5//
  method variarIntensidadLimite(unValorLimite) { intensidad = unValorLimite }

  method puedeLiberarse() = self.tieneIntensidadElevada() && self.condicionExtraDeLiberacion()

  method condicionExtraDeLiberacion() = true //EMOCIONES SIN CONDICION EXTRA//

  method liberar(unEvento) {
    if(self.puedeLiberarse())
      self.variarIntensidad(unEvento.impacto())
      self.consecuenciaExtraDeLiberacion(unEvento)
  }

  method consecuenciaExtraDeLiberacion(unEvento) {}

  method tieneIntensidadElevada() = intensidad > intensidadLimite

  method variarIntensidad(unaCantidad) { intensidad += unaCantidad }
}

class Furia inherits Emocion(intensidad = 100) {
  const property palabrotas = []

  method aprenderPalabrota(unaPalabrota) {
    palabrotas.add(unaPalabrota)
  }

  method olvidarPalabrota(unaPalabrota) {
    palabrotas.remove(unaPalabrota)
  }

  override method consecuenciaExtraDeLiberacion(unEvento) {
    palabrotas.remove(palabrotas.last())
  }

  override method condicionExtraDeLiberacion() = self.conoceUnaGranPalabrota()

  method conoceUnaGranPalabrota() {
    return palabrotas.any({ p => p.size() > 7 })
  }
}

class Alegria inherits Emocion {
  override method variarIntensidad(unaCantidad) {
    const nuevaIntensidad = intensidad - unaCantidad

    if(nuevaIntensidad < 0) intensidad = nuevaIntensidad * (-1)
  }

  override method condicionExtraDeLiberacion() = self.cantidadEventosVividos().even()
}

class Tristeza inherits Emocion {
  var property causa = "Melancolia"

  method cambiarCausa(nuevaCausa) { causa = nuevaCausa }

  override method consecuenciaExtraDeLiberacion(unEvento) {
    self.cambiarCausa(unEvento.descripcionEvento())
  } 

  override method condicionExtraDeLiberacion() = causa != "Melancolia"
}

class OtraEmocion inherits Emocion {
  override method condicionExtraDeLiberacion() = self.cantidadEventosVividos() > intensidad
}

const desagrado = new OtraEmocion()

const temor = new OtraEmocion()


//INTENSAMENTE 2//
class Ansiedad inherits Emocion { //TODOS LA TIENEN... DE DISTINTAS MANERA//
  var property tazasDeTe //CADA ANSIEDAD TIENE UNA CANTIDAD DE TAZAS DE TÉ PARA BEBER// 

  override method condicionExtraDeLiberacion() = tazasDeTe == 0

  //NADIE QUIERE VERLA TRABAJANDO SIN SU TAZA DE TÉ (ES INTENSA)... POR ESO LO COMPRAN MÁS// 
  override method consecuenciaExtraDeLiberacion(unEvento) { tazasDeTe += unEvento.impacto() }
}

/*
  Conceptos como HERENCIA y POLIMORFISMO fueron de utilidad a la hora de inventar una emocion diferente, pero que siga siendo capaz de
  RESPONDER / RECONOCER los metodos que conoce toda emocion (ademas de incluir caracteristicas própias). Tambien, evita la repeticion de codigo.
*/