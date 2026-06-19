function f(seed : int) : int;

// No hay dos iguales
axiom (forall seed1, seed2 : int :: seed1 != seed2 ==> f(seed1) != f(seed2));

procedure TestUninterpretedFunction(x : int, y : int)
  requires x != y;
{
  var resA, resB: int;
  resA := f(6);
  resB := f(4);

  assert false;
}