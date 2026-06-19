# Problema

Queremos que al pasar dos contextos distintos como parametro ambos tengan senders distintos, ademas nos gustaria que pueda ser extendido a otras funciones nativas de contextos.

Para ello vamos a centrarnos en el siguiente codigo

    #[spec(prove)]
    public fun variso_ctx_sender(ctx1 : &mut TxContext, ctx2 : &mut TxContext){
        ensures(ctx1.sender() != ctx2.sender());
    }

Lo que hacemos es generar el boogie con el prover y luego modificarlo a mano para ver si podemos cambair el funcionamiento de los contextos para que ambos devuelvan valores distintos de sender. De normal el prover unicamente devuelve un valor de sender independientemente de que sean variables distintas.

# Idea

La idea que se me ocurrio es la de asociar una semilla a cada contexto, de esta forma el boogie generaria resultados dependiendo de la semilla que se le pase a la funcion de sender.

# Implementacion

Para ello hay que entender que la funcion de sender lo unico que hace en move es llamar a la funcion native_sender la cual le asigna un valor unico al sender. Ademas en boogie el funcionamiento es identico:

    function {:inline} $2_tx_context_sender$pure(_$t0: $2_tx_context_TxContext) returns ($ret0: int){
        (var $t1 := $2_tx_context_native_sender();
        $t1)
    }

Esta funcion native_sender se implementa como una funcion sin interpretar que cuenta con un unico axioma que verficia que se este devolviendo un Addres valido:

    function $2_tx_context_native_sender(): int;

    axiom $IsValid'address'($2_tx_context_native_sender());

Luego la modificacion propuesta es agregar un valor int que se use como semilla y un axioma que indique que no hay dos semillas iguales que produscan el mismo sender:

    function $2_tx_context_native_sender(seed : int): int;

    axiom (forall seed : int :: $IsValid'address'($2_tx_context_native_sender(seed)));

    axiom (forall seedA, seedB : int :: seedA != seedB ==> 
            $2_tx_context_native_sender(seedA) != $2_tx_context_native_sender(seedB));

A la hora de usarlo quedaria algo asi:

    function {:inline} $2_tx_context_sender$pure(_$t0: $2_tx_context_TxContext, seed :int) returns ($ret0: int){
        (var $t1 := $2_tx_context_native_sender(seed);
        $t1)
    }

    caso() {
        ...
        $t6 := $2_tx_context_sender$pure($t5, 0);
        $t8 := $2_tx_context_sender$pure($t7, 1);
        ...
    }


# Resultados

## La semilla fue un EXITO 

Al verificar los senders usando dos semillas ditintas efectivamente la funcion $2_tx_context_native_sender efectivamente se detecta que son distintos los senders:

    Boogie program verifier finished with 0 errors

## Test con axioma reflejando comportamiento normal del prover

En este caso el prover fallo y la razon era que la funcion $2_tx_context_native_sender devolvia siempre el mimso valor:
    
    $2_tx_context_native_sender -> {
        0 -> 2
        1 -> 2
        else -> 2
    }

## Test con misma semilla

Para ver que en efecto el valor de la semilla esta funcionando como debe, que le pase la misma semilla y el prover fallo como era esperado:
    
    $2_tx_context_native_sender -> {
      0 -> 1
      else -> 1
    }