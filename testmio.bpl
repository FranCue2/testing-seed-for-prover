function f(b: bool, x : int) : int;

axiom (forall x : int, b : bool :: b <==> f(b,x) == x);

procedure TestUninterpretedFunction(b: bool, x: int)
{
  var resA, resB: int;

  resA := f(true, x);
  resB := f(false, x);

  assert resB != x; 
  assert resA == x;

  assert resB != resA;

  assert resB == x;
}