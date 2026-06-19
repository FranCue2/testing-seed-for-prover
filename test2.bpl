// 1. Declaramos una función matemática que toma un entero y devuelve un entero.
// No tiene llaves {}, no tiene cuerpo. Es una "caja negra".
function f(x: int) : int;

// 2. Definimos axiomas para darle semántica a la caja negra.
// Aquí decimos explícitamente: "Para todo x e y, si x es menor que y, entonces f(x) es menor que f(y)".
// Es decir, f es una función estrictamente creciente.
axiom (forall x: int, y: int :: x < y ==> f(x) < f(y));

procedure TestUninterpretedFunction(a: int, b: int)
  requires a < b; // Asumimos que a es estrictamente menor que b
{
  var resA, resB: int;

  // Evaluamos la función matemática pura y guardamos los resultados en variables locales
  resA := f(a);
  resB := f(b);

  // Comprobamos una aserción en medio del código
  assert resA < resB; 
}