import 'dart:ui' show Color;

import '../models/product.dart';

const ProductColor _midnight = ProductColor(
  name: 'Midnight',
  value: Color(0xFF23262E),
);
const ProductColor _bone = ProductColor(name: 'Bone', value: Color(0xFFE6E0D4));
const ProductColor _sage = ProductColor(name: 'Sage', value: Color(0xFF8FA593));
const ProductColor _ember = ProductColor(
  name: 'Ember',
  value: Color(0xFFD0583A),
);
const ProductColor _cobalt = ProductColor(
  name: 'Cobalt',
  value: Color(0xFF2F5BD3),
);
const ProductColor _chalk = ProductColor(
  name: 'Chalk',
  value: Color(0xFFF4F1EA),
);
const ProductColor _forest = ProductColor(
  name: 'Forest',
  value: Color(0xFF3F6B4F),
);
const ProductColor _roseQuartz = ProductColor(
  name: 'Rose Quartz',
  value: Color(0xFFD9A6A0),
);
const ProductColor _stone = ProductColor(
  name: 'Stone',
  value: Color(0xFF8A8172),
);
const ProductColor _olive = ProductColor(
  name: 'Olive',
  value: Color(0xFF5E6B3A),
);

const List<int> _euSizes = [40, 41, 42, 43, 44, 45];

const Product aeroGlide = Product(
  id: 'aero-glide',
  name: 'Aero Glide',
  subtitle: 'Running',
  description:
      'A featherweight racer with a snappy foam midsole and a mesh upper '
      'that keeps air moving. Made for tempo days and race morning.',
  highlight: 'Breathable mesh',
  category: ProductCategory.running,
  price: 149,
  rating: 4.8,
  reviewCount: 212,
  imagePath: 'assets/images/aero_glide.png',
  availableColors: [_cobalt, _midnight, _bone],
  availableSizes: _euSizes,
  stockCount: 24,
);

const Product cloudStep = Product(
  id: 'cloud-step',
  name: 'Cloud Step',
  subtitle: 'Casual · Knit',
  description:
      'A slip-on knit sneaker with a pillowy footbed and a flexible sole. '
      'Easy to pull on, easy to wear from morning coffee to late dinner.',
  highlight: 'Soft knit upper',
  category: ProductCategory.casual,
  price: 119,
  originalPrice: 149,
  rating: 4.6,
  reviewCount: 98,
  imagePath: 'assets/images/cloud_step.png',
  availableColors: [_bone, _sage, _midnight],
  availableSizes: _euSizes,
  soldOutSizes: {40},
  stockCount: 15,
);

const Product courtClassic = Product(
  id: 'court-classic-87',
  name: "Court Classic '87",
  subtitle: 'Casual · Leather',
  description:
      'A tennis-inspired low top in full-grain leather with a cupsole that '
      'softens with every wear. A clean classic that goes with everything.',
  highlight: 'Premium leather',
  category: ProductCategory.casual,
  price: 99,
  rating: 4.7,
  reviewCount: 341,
  imagePath: 'assets/images/court_classic.png',
  availableColors: [_chalk, _forest],
  availableSizes: _euSizes,
  soldOutSizes: {41, 45},
  stockCount: 3,
);

const Product vantaRunner = Product(
  id: 'vanta-runner',
  name: 'Vanta Runner',
  subtitle: 'Running',
  description:
      'A lightweight daily trainer with a responsive foam midsole and an '
      'engineered knit upper that breathes on long runs. Built for road '
      'miles, comfortable enough for everything after.',
  highlight: 'Breathable knit',
  category: ProductCategory.running,
  price: 169,
  originalPrice: 199,
  rating: 4.9,
  reviewCount: 1284,
  imagePath: 'assets/images/vanta_runner.png',
  availableColors: [_midnight, _bone, _sage, _ember],
  availableSizes: _euSizes,
  soldOutSizes: {44},
  stockCount: 32,
);

const Product nimbusMid = Product(
  id: 'nimbus-mid',
  name: 'Nimbus Mid',
  subtitle: 'Limited Edition',
  description:
      'A numbered mid-top drop with a suede overlay, tonal laces and a '
      'cushioned collar. Only a few hundred pairs were ever made.',
  highlight: 'Numbered pairs',
  category: ProductCategory.limited,
  price: 229,
  rating: 4.9,
  reviewCount: 64,
  imagePath: 'assets/images/nimbus_mid.png',
  availableColors: [_roseQuartz, _midnight],
  availableSizes: _euSizes,
  stockCount: 0,
);

const Product trailRidge = Product(
  id: 'trail-ridge-gtx',
  name: 'Trail Ridge GTX',
  subtitle: 'Trail · Waterproof',
  description:
      'A rugged trail shoe with a waterproof membrane, a rock plate and deep '
      'lugs that grip on mud and loose gravel. Ready for any weather.',
  highlight: 'Waterproof',
  category: ProductCategory.trail,
  price: 159,
  rating: 4.5,
  reviewCount: 127,
  imagePath: 'assets/images/trail_ridge.png',
  availableColors: [_stone, _olive],
  availableSizes: _euSizes,
  stockCount: 18,
);

const List<Product> sampleProducts = [
  aeroGlide,
  cloudStep,
  courtClassic,
  vantaRunner,
  nimbusMid,
  trailRidge,
];
