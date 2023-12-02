import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: const Color(0xFF4D4DC6),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        // Add SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('images/logo.png'),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Welcome to ThinU',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4D4DC6),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('About Us:'),
              _buildSectionContent(
                'We are a team of innovative minds dedicated to creating exceptional Flutter applications. '
                'Our mission is to craft cutting-edge, user-centric solutions that elevate the user experience.',
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Our Core Values:'),
              _buildSectionContentDetails(
                'Innovation:',
                'We thrive on pushing the boundaries of what\'s possible in mobile app development.',
                'User-Centric:',
                'Our users are at the heart of everything we do, and we prioritize their needs and preferences.',
                'Quality:',
                'We are committed to delivering high-quality, bug-free applications.',
                'Collaboration:',
                'Teamwork is key, and we value open communication and collaboration.',
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Contact Us:'),
              _buildContactInfo(Icons.email, 'Email', 'thinu@gmail.com'),
              _buildContactInfo(Icons.phone, 'Phone', '+959 914 567 890'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4D4DC6),
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContentDetails(
    String title1,
    String content1,
    String title2,
    String content2,
    String title3,
    String content3,
    String title4,
    String content4,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildDetailsItem(title1, content1),
          _buildDetailsItem(title2, content2),
          _buildDetailsItem(title3, content3),
          _buildDetailsItem(title4, content4),
        ],
      ),
    );
  }

  Widget _buildDetailsItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4D4DC6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String title, String subtitle) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, color: const Color(0xFF4D4DC6)),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
