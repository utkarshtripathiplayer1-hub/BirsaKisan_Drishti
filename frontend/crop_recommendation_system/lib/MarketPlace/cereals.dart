import 'package:crop_recommendation_system/MarketPlace/irrigation.dart';
import 'package:flutter/material.dart';

// Import your already created pages here
// import 'categories_page.dart';
// import 'add_market_page.dart';

class Cereals extends StatelessWidget {
  const Cereals({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Market Place",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
          weight: 40.0,
        ),
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///======================
                /// Categories
                ///======================
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    IconButton(
                      iconSize: 40,
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => const AddCrop(),
                        //   ),
                        // );
                      },
                      icon: const Icon(Icons.add_circle),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryButton(
                      title: "Cereals",
                      image: "assets/images/cereals.png",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Cereals()),
                        );
                      },
                    ),

                    CategoryButton(
                      title: "Irrigation",
                      image: "assets/images/irrigation.png",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Irrigation()),
                        );
                      },
                    ),

                    CategoryButton(
                      title: "Fertilizers",
                      image: "assets/images/fertilizers.png",
                      onTap: () {},
                    ),

                    CategoryButton(
                      title: "Oil Seeds",
                      image: "assets/images/oil_seeds.png",
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                const Text(
                  "Market Prices",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                CropCard(
                  image: "assets/images/wheat.png",
                  title: "Wheat",
                  price: "₹2900/q",
                  graph: "assets/images/graph_up.png",
                  percentage: "+5%",
                ),

                const SizedBox(height: 18),

                CropCard(
                  image: "assets/images/sugarcane.png",
                  title: "Sugar Cane",
                  price: "₹3200/q",
                  graph: "assets/images/graph_down.png",
                  percentage: "-2%",
                ),

                const SizedBox(height: 18),

                CropCard(
                  image: "assets/images/rye.jpg",
                  title: "Rye",
                  price: "₹7500/q",
                  graph: "assets/images/graph_up.png",
                  percentage: "+4%",
                ),

                const SizedBox(height: 20),

                CropCard(
                  image: "assets/images/maize.jpg",
                  title: "Maize",
                  price: "₹2450/q",
                  graph: "assets/images/graph_up.png",
                  percentage: "+6%",
                ),

                const SizedBox(height: 20),

                CropCard(
                  image: "assets/images/bajra.jpg",
                  title: "Bajra",
                  price: "₹1600/q",
                  graph: "assets/images/graph_down.png",
                  percentage: "-8%",
                ),

                const SizedBox(height: 18),
                CropCard(
                  image: "assets/images/rice.jpg",
                  title: "Rice",
                  price: "₹4500/q",
                  graph: "assets/images/graph_down.png",
                  percentage: "-3%",
                ),

                const SizedBox(height: 18),
                CropCard(
                  image: "assets/images/barley.jpg",
                  title: "Barley",
                  price: "₹2400/q",
                  graph: "assets/images/graph_up.png",
                  percentage: "+4%",
                ),

                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 75,
        child: Column(
          children: [
            CircleAvatar(radius: 30, backgroundImage: AssetImage(image)),

            const SizedBox(height: 8),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class CropCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String graph;
  final String percentage;

  const CropCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.graph,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.green.withOpacity(0.10),
        border: Border.all(color: Colors.green.shade300),
      ),

      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(image, width: 90, height: 90, fit: BoxFit.cover),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(price, style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 55,
                  child: Image.asset(graph, fit: BoxFit.contain),
                ),

                const SizedBox(height: 6),

                Text(
                  percentage,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
