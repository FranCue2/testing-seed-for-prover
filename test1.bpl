procedure MultiplyByAddition(x: int, y: int) returns (res: int)
  requires x >= 0; // Asumimos que x no es negativo para que el bucle termine
  ensures res == x * y; // Queremos garantizar que el resultado es la multiplicación
{
  var i: int; // Declaración de variable local
  res := 0;
  i := 0;

  while (i < x)
    invariant i <= x;             // El contador no se pasa del límite
    invariant res == i * y;       // La propiedad clave que relaciona las variables en cada paso
  {
    res := res + y;
    i := i + 1;
  }
}