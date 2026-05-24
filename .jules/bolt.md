## 2024-05-20 - Expensive Operations in ListView Builders and Loops
**Learning:** Found instances where `DateFormat` instantiations and `O(N)` list searches were placed inside Dart loops and `ListView.builder` methods. This creates O(N^2) complexity and redundant memory allocations which can cause jank on long lists.
**Action:** Always pre-compute maps and cache expensive instances like `DateFormat` outside of loops or list builder methods.
