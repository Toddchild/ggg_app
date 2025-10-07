class Service {
  final String id;
  final String name;
  final String description;
  final int minutes;
  final double price;

  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.minutes,
    required this.price,
  });
}

const demoServices = <Service>[
  Service(
    id: 'svc_haircut',
    name: 'Haircut',
    description: 'Classic cut and finish.',
    minutes: 45,
    price: 45.00,
  ),
  Service(
    id: 'svc_color',
    name: 'Color',
    description: 'Single process color.',
    minutes: 90,
    price: 95.00,
  ),
  Service(
    id: 'svc_beard',
    name: 'Beard Trim',
    description: 'Line-up and trim.',
    minutes: 20,
    price: 20.00,
  ),
];
