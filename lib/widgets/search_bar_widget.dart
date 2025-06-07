import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final bool isSearchActive;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const SearchBarWidget({
    
    required this.isSearchActive,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildSearchField(),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      onChanged: onSearchChanged, // Proporciona feedback en tiempo real
      decoration: InputDecoration(
        hintText: 'Buscar...',
        prefixIcon: Icon(Icons.search),
        suffixIcon: isSearchActive
            ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  onSearchChanged(''); // Limpiar la búsqueda
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
