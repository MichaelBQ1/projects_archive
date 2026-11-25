const result = document.getElementById('result');
const bal = document.getElementById('balance');
function randint(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}
let balance = 1000;
let cur1 = 0;
let cur2 = 0;
function save1() {
  cur1 = Number(document.getElementById('message1').value);
}
function save2() {
  cur2 = Number(document.getElementById('message2').value);
}
function play() {
  save1()
  save2()
  if (cur2 > 0 && cur2 <= balance) {
    let rand = randint(2, 12);
    if (cur1 === rand) {
      result.textContent = "Вы выиграли!";
      balance = balance + (cur2 * 4)
    } else {
      result.textContent = `Вы проиграли, выпало ${rand}.`;
      balance = balance - cur2
    }
    bal.textContent = `Баланс: ${balance}`;
  }
  else {
    result.textContent = "Некорректная ставка!";
  }
}
