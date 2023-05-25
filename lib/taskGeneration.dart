import 'dart:math';
import 'package:trotter/trotter.dart';
import 'task.dart';

void shuffle(List elements, [int start = 0, int? end, Random? random]) {
  random ??= Random();
  end ??= elements.length;
  var length = end - start;
  while (length > 1) {
    var pos = random.nextInt(length);
    length--;
    var tmp1 = elements[start + pos];
    elements[start + pos] = elements[start + length];
    elements[start + length] = tmp1;
  }
}

double randomDouble([double min = 0, double max = 1, int pres = 2]) {
  return double.parse(
      (min + r.nextDouble() * (max - min)).toStringAsFixed(pres));
}

void extendRandom(List a, [double min = 0, double max = 1, int pres = 2]) {
  var l = [];
  Random r = Random();
  while (a.length != 4) {
    var t = (min + r.nextDouble() * (max - min))
        .toStringAsFixed(pres)
        .replaceAll('.', ',');
    if (l.contains(t) || a.contains(t)) continue;
    l.add(t);
    a.add(t);
  }
}

var now = DateTime.now();
Random r = Random(now.millisecondsSinceEpoch);

var tasks = [
  // 0 task
  () {
    var m = [2, 3][r.nextInt(2)];
    var n1 = r.nextInt(6) + 2;
    var n2 = r.nextInt(5) + m;
    while (n1 == n2) {
      n2 = r.nextInt(5) + m;
    }
    var data = {};
    data['n1'] = n1;
    data['n2'] = n2;
    data['m'] = m;
    var t = [];
    for (int i = 0; i < n2; i++) {
      t.add(i);
    }
    var c1 = Combinations(2, t);
    t = [];
    for (int i = 0; i < n1; i++) {
      t.add(i);
    }
    var c2 = Combinations(m - 2, t);
    t = [];
    for (int i = 0; i < n1 + n2; i++) {
      t.add(i);
    }
    var c3 = Combinations(m, t);
    var ri = ((c1.length * c2.length) / c3.length)
        .toStringAsFixed(2)
        .replaceAll('.', ',');
    var ans = [ri];
    extendRandom(ans, 0.1, 0.7);
    shuffle(ans);
    return Task(data: data, answers: ans, rightAns: ans.indexOf(ri));
  },
  // 1 task
  () {
    var m = [2, 3, 4][r.nextInt(3)];
    var n1 = r.nextInt(3) + 5; // 5,6,7
    var n2 = r.nextInt(4) + 2; // 2,3,4,5
    var data = {};
    data['n1'] = n1;
    data['n2'] = n2;
    data['m'] = m;
    var t = [];
    for (int i = 0; i < n1; i++) {
      t.add(i);
    }
    var c1 = Combinations(m, t);
    t = [];
    for (int i = 0; i < n2; i++) {
      t.add(i);
    }
    var c2 = Combinations(4 - m, t);
    t = [];
    for (int i = 0; i < n1 + n2; i++) {
      t.add(i);
    }
    var c3 = Combinations(4, t);
    var ri = ((c1.length * c2.length) / c3.length)
        .toStringAsFixed(2)
        .replaceAll('.', ',');
    var ans = [ri];
    extendRandom(ans, 0.1, 0.7);
    shuffle(ans);
    return Task(data: data, answers: ans, rightAns: ans.indexOf(ri));
  },

  // 2 task
  () {
    var p1 = randomDouble(0.1, 0.4, 1);
    var p2 = randomDouble(0.1, 0.4, 1);
    while (p2 == p1) {
      p2 = randomDouble(0.1, 0.4, 1);
    }
    var data = {};
    data['p1'] = p1;
    data['p2'] = p2;
    var ri = (1 - (1 - p1) * (1 - p2)).toStringAsFixed(2).replaceAll('.', ',');
    var ans = [ri];
    extendRandom(ans, 0.1, 0.7);
    shuffle(ans);
    return Task(data: data, answers: ans, rightAns: ans.indexOf(ri));
  },

  // 3 task
  () {
    var p1 = randomDouble(0.7, 0.9, 2);
    var p2 = randomDouble(0.7, 0.9, 2);
    while (p1 == p2) {
      p2 = randomDouble(0.7, 0.9, 2);
    }
    var data = {};
    data['p1'] = p1;
    data['p2'] = p2;
    var ri = ((p1) * (1 - p2) + (p2) * (1 - p1))
        .toStringAsFixed(2)
        .replaceAll('.', ',');
    var ans = [ri];
    extendRandom(ans, 0.1, 0.7);
    shuffle(ans);
    return Task(data: data, answers: ans, rightAns: ans.indexOf(ri));
  },

  // 4 task
  () {
    var n1 = r.nextInt(20) + 40;
    var n2 = 100 - n1;
    var p1 = randomDouble(0.3, 0.4, 1);
    var p2 = randomDouble(0.1, 0.2, 1);
    while (p1 == p2) {
      p2 = randomDouble(0.1, 0.2, 1);
    }
    var data = {};
    data['n1'] = n1;
    data['n2'] = n2;
    data['p1'] = p1;
    data['p2'] = p2;
    var ri = (((1 - p1) * n1 + (1 - p2) * n2) / 100)
        .toStringAsFixed(2)
        .replaceAll('.', ',');
    var ans = [ri];
    extendRandom(ans, 0.1, 0.9, 3);
    // путаем людей
    ans[3] =
        ((p1 * n1 + p2 * n2) / 100).toStringAsFixed(2).replaceAll('.', ',');
    shuffle(ans);
    return Task(data: data, answers: ans, rightAns: ans.indexOf(ri));
  },

  // 5 task
  () {
    var p = r.nextInt(20) + 70;
    var n = r.nextInt(4) + 4;
    var m = r.nextInt(3) + 2;
    var data = {};
    data['n'] = n;
    data['p'] = p;
    data['m'] = m;
    var t = [];
    for (int i = 0; i < n; i++) {
      t.add(i);
    }
    var c1 = Combinations(m, t);
    var p1 = p / 100;
    var ritemp = c1.length.toDouble() * pow(p1, m) * pow((1 - p1), n - m);
    var ri = (ritemp).toStringAsFixed(5).replaceAll('.', ',');
    var ans = [ri];
    extendRandom(ans, 0.1, 0.9, 5);
    // путаем людей
    ans[3] = (1 - ritemp).toStringAsFixed(5).replaceAll('.', ',');
    shuffle(ans);
    return Task(data: data, answers: ans, rightAns: ans.indexOf(ri));
  },

  // 6 task
  () {
    var x1 = r.nextInt(3) + 1;
    var x2 = r.nextInt(2) + 4;
    var x3 = r.nextInt(4) + 6;
    var p1 = randomDouble(0.1, 0.2, 1);
    var p2 = randomDouble(0.3, 0.4, 1);
    var p3 = (1 - p1 - p2).toStringAsFixed(1).replaceAll('.', ',');
    var data = {};
    data['x1'] = x1;
    data['x2'] = x2;
    data['x3'] = x3;
    data['p1'] = p1;
    data['p2'] = p2;
    data['p3'] = p3;
    var ri = [
      0,
      p1.toStringAsFixed(1).replaceAll('.', ','),
      (p1 + p2).toStringAsFixed(1).replaceAll('.', ','),
      1
    ];
    var ans = [ri];
    // путаем людей
    ans.add([
      p1.toStringAsFixed(1).replaceAll('.', ','),
      p2.toStringAsFixed(1).replaceAll('.', ','),
      p3,
      1
    ]);
    ans.add([
      0,
      p1.toStringAsFixed(1).replaceAll('.', ','),
      p2.toStringAsFixed(1).replaceAll('.', ','),
      0
    ]);
    ans.add([
      0,
      randomDouble(0.2, 0.5, 1).toStringAsFixed(1).replaceAll('.', ','),
      randomDouble(0.6, 0.9, 1).toStringAsFixed(1).replaceAll('.', ','),
      0
    ]);
    shuffle(ans);
    return Task(data: data, answers: ans, rightAns: ans.indexOf(ri));
  },
  // 7 task
  () {
    var p1 = randomDouble(0.01, 0.09, 2);
    var p2 = randomDouble(0.1, 0.2, 1);
    var p3 = randomDouble(0.3, 0.4, 1);
    if (r.nextBool()) {
      var t = p1;
      p1 = p2;
      p2 = t;
    }
    var data = {};
    data['p1'] = p1;
    data['p2'] = p2;
    data['p3'] = p3;
    var t = (1 - p1 - p2 - p3);
    var a = randomDouble(0.1, t - 0.01, 2);
    var b = t - a;
    var ri = [
      a.toStringAsFixed(2).replaceAll('.', ','),
      b.toStringAsFixed(2).replaceAll('.', ',')
    ];
    var ans = [ri];
    // путаем людей
    ans.add([
      a.toStringAsFixed(2).replaceAll('.', ','),
      (b + 0.05).toStringAsFixed(2).replaceAll('.', ',')
    ]);
    ans.add([
      (b + 0.02).toStringAsFixed(2).replaceAll('.', ','),
      (a - 0.04).toStringAsFixed(2).replaceAll('.', ',')
    ]);
    ans.add([
      randomDouble(0.1, 0.4, 2).toStringAsFixed(2).replaceAll('.', ','),
      randomDouble(0.5, 0.9, 2).toStringAsFixed(2).replaceAll('.', ',')
    ]);
    shuffle(ans);
    return Task(data: data, answers: ans, rightAns: ans.indexOf(ri));
  },

  // 8 task
  () {
    var data = {};

    var ri = [
      0,
      'x',
      1,
    ];
    var ans = [ri];
    // путаем людей
    ans.add([
      0,
      '1',
      0,
    ]);
    ans.add([
      0,
      '1',
      1,
    ]);
    ans.add([
      1,
      'x',
      1,
    ]);
    shuffle(ans);
    return Task(data: data, answers: ans, rightAns: ans.indexOf(ri));
  },

  // 9 task
  () {
    f(int x) {
      if (x <= 0) return 0;
      if (x <= 6) return x * x / 36;
      return 1;
    }

    var x1 = r.nextInt(10) - 4;
    var x2 = r.nextInt(10) - 4;
    while (x1 == x2) {
      x2 = r.nextInt(10) - 4;
    }
    if (x1 > x2) {
      var t = x1;
      x1 = x2;
      x2 = t;
    }
    var data = {};
    data['x1'] = x1;
    data['x2'] = x2;
    var ri = (f(x2) - f(x1)).toStringAsFixed(2).replaceAll('.', ',');
    var ans = [ri];
    // путаем людей
    extendRandom(ans, 0.1, 0.9, 2);
    ans.add(f(x2 - x1).toStringAsFixed(2).replaceAll('.', ','));
    shuffle(ans);
    var k = ans.indexOf(ri);
    for (var i = 0; i < 4; i++) {
      if (ans[i] == '0,00') ans[i] = '0';
      if (ans[i] == '1,00') ans[i] = '1';
    }
    return Task(data: data, answers: ans, rightAns: k);
  },
  // 10 task
  () {
    var la = r.nextInt(8) + 2;
    var data = {};
    data['la'] = la;
    var ri = [la, la * la];
    var ans = [ri];
    // путаем людей
    ans.add([la * la, la]);
    ans.add([la, la]);
    ans.add([la * la, la * la]);
    shuffle(ans);
    return Task(data: data, answers: ans, rightAns: ans.indexOf(ri));
  },

  // 11 task
  () {
    var x1 = r.nextInt(3) - 4;
    var x2 = r.nextInt(3);
    var x3 = r.nextInt(3) + x2 + 1;
    var p1 = randomDouble(0.1, 0.2, 1);
    var p2 = randomDouble(0.3, 0.4, 1);
    var p3 = double.parse((1 - p1 - p2).toStringAsFixed(1));
    var data = {};
    data['x1'] = x1;
    data['x2'] = x2;
    data['x3'] = x3;
    data['p1'] = p1;
    data['p2'] = p2;
    data['p3'] = p3;
    var m1 = (p1 * x1 + p2 * x2 + p3 * x3);
    var d = (p1 * x1 * x1 + p2 * x2 * x2 + p3 * x3 * x3 - m1 * m1)
        .toStringAsFixed(2);
    var m = m1.toStringAsFixed(2);
    var ri = [
      m,
      d,
    ];
    var ans = [ri];
    var t = randomDouble(0.2, 0.8, 2).toStringAsFixed(2);
    // путаем людей
    ans.add([d, m]);
    ans.add([d, t]);
    ans.add([t, m]);
    shuffle(ans);
    return Task(data: data, answers: ans, rightAns: ans.indexOf(ri));
  },

  // 12 task
  () {
    var x = r.nextInt(4) + 3;
    var data = {};
    data['x'] = x;
    var ri = [pow(x, 4), 36 * 4];
    var ans = [ri];
    // путаем людей
    ans.add([x * x, 36]);
    ans.add([pow(x, 3), 36 * 3]);
    ans.add([(x - 1) * (x - 1), 36]);
    shuffle(ans);
    return Task(data: data, answers: ans, rightAns: ans.indexOf(ri));
  }
];
// void main() {
//   tasks[6]();
// }
