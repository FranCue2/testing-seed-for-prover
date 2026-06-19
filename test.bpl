procedure Abs(x: int) returns (y: int)
  requires true; // Precondición trivial: acepta cualquier entero
  ensures y >= 0; // Postcondición 1: el resultado siempre es positivo o cero
  ensures (x >= 0 ==> y == x) && (x < 0 ==> y == -x); // Postcondición 2: definición exacta
{
  // Cuerpo imperativo del procedimiento
  if (x < 0) {
    y := -x;
  } else {
    y := x;
  }
}