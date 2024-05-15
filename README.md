# Birds

## Installation
```bash
git clone git@github.com:kowusu/birds.git
cd birds
bundle install
rails db:create db:migrate #optional: db:seed
#optional: rails dev:cache # toggle on/off development caching
rails server
```
## Solution Overview
For this project, I implemented the solution using Ruby on Rails, supported by a PostgreSQL database. Here's a breakdown of the key components and strategies employed:

### Using PostgreSQL and Common Table Expressions (CTEs)
To efficiently manage and query hierarchical data, I utilized PostgreSQL's advanced querying capabilities, specifically Common Table Expressions (CTEs). CTEs are particularly useful for recursive queries. The use of CTEs helps in significantly reducing the complexity of queries and minimizes the number of round trips between the application server and the database server, thus enhancing performance.

### Caching Implementation
To further improve response times, especially for frequently accessed data, I implemented caching within the application. Caching is handled via Rails’ built-in caching mechanisms, which are configured to store commonly retrieved data in memory. This approach significantly speeds up response times for subsequent fetches, as the system can serve data from the cache rather than performing time-consuming database queries.

### Benefits and Justification

The integration of these technologies and strategies provides several benefits:

- **Reduced Server Load**: By leveraging CTEs for complex queries, the load on the application server is minimized as the database handles the heavy lifting of data processing.
- **Increased Performance**: The use of PostgreSQL ensures that the system can handle large volumes of data without a degradation in performance, which is crucial for maintaining a smooth user experience as the application scales.
- **Enhanced Responsiveness**: With caching, commonly accessed data is quickly retrievable, which not only speeds up the application’s responsiveness but also reduces database access costs and server load.

## Alternative Solutions
### Data Preprocessing with Rake Tasks
An alternative approach to managing data involves preprocessing large datasets using Rake tasks. This method would involve setting up periodic tasks that process and structure data into a more query-friendly format. For example, updating all nodes with precomputed descendant IDs can be done overnight using a cronjob to minimize impact on database performance during peak hours.
```ruby
namespace :data_preprocess do
  desc "Preprocess and update node descendant information"
  task update_descendants: :environment do
    Node.all.each do |node|
      node.update_descendants
    end
  end
end
```
This approach is particularly useful when dealing with extremely large datasets where real-time processing would significantly hinder performance.

### Asynchronous Processing with Sidekiq
For operations that are too intensive to run during normal user interactions, using a background job processor like Sidekiq can be effective. This would offload tasks such as recalculating hierarchical data or processing large imports to background workers, thus keeping the application responsive:

```ruby
class NodeUpdateWorker
  include Sidekiq::Worker

  def perform(node_id)
    node = Node.find(node_id)
    node.update_descendants
  end
end
```
This method allows for the handling of heavy tasks asynchronously, thus enhancing user experience by not blocking web server processes.

### Database Triggers for Hierarchical Data Integrity

Another alternative to managing hierarchical data involves the use of database triggers to automatically maintain `ancestor_ids` and `descendant_ids`. This approach leverages the database's capabilities to ensure data integrity and can significantly reduce application-level complexity.

#### Ancestor ID Triggers

- **Purpose**: Automatically update `ancestor_ids` when new nodes are inserted or when a node's parent changes. This ensures that each node always has a correct and up-to-date path to the root, which is crucial for operations that depend on the full hierarchy.

- **Implementation**:
  ```sql
  CREATE OR REPLACE FUNCTION update_ancestor_ids()
  RETURNS TRIGGER AS $$
  BEGIN
      -- Logic to concatenate ancestor IDs from the parent node, ensuring all ancestors are included
      RETURN NEW;
  END;
  $$ LANGUAGE plpgsql;

  CREATE TRIGGER trg_update_ancestor_ids
  BEFORE INSERT OR UPDATE ON nodes
  FOR EACH ROW
  EXECUTE PROCEDURE update_ancestor_ids();

#### Descendant ID Triggers

- **Purpose**: Keep `descendant_ids` updated in real-time as nodes are added or modified within the tree. This trigger would help in quickly retrieving all descendants of a given node without recursively querying the database.

- **Implementation**:
  ```sql
  CREATE OR REPLACE FUNCTION update_descendant_ids()
  RETURNS TRIGGER AS $$
  BEGIN
      -- Logic to append new node IDs to the descendant lists of all ancestor nodes
      RETURN NEW;
  END;
  $$ LANGUAGE plpgsql;

  CREATE TRIGGER trg_update_descendant_ids
  AFTER INSERT OR UPDATE ON nodes
  FOR EACH ROW
  EXECUTE PROCEDURE update_descendant_ids();
  ```

### Combining Database Triggers with Stored Procedures for CTE Queries

For more sophisticated data management, combining database triggers with stored procedures that utilize CTEs offers a robust solution for maintaining and querying hierarchical data:

- **Stored Procedures for CTE Queries**: Create stored procedures to handle complex recursive queries, such as fetching all descendants or ancestors of a node, using CTEs to simplify and optimize query execution.

- **Trigger Integration**:
  ```sql
  -- Example of a stored procedure using a CTE to fetch descendants
  CREATE OR REPLACE FUNCTION get_descendants(node_id INT)
  RETURNS TABLE(id INT, name TEXT) AS $$
  BEGIN
      RETURN QUERY
      WITH RECURSIVE descendants AS (
          SELECT id, name
          FROM nodes
          WHERE parent_id = node_id
      UNION ALL
          SELECT n.id, n.name
          FROM nodes n
          JOIN descendants d ON d.id = n.parent_id
      )
      SELECT * FROM descendants;
  END;
  $$ LANGUAGE plpgsql;

  -- Trigger that updates hierarchy using the stored procedure
  CREATE TRIGGER trg_update_node_hierarchy
  AFTER INSERT OR UPDATE ON nodes
  FOR EACH ROW
  EXECUTE PROCEDURE update_hierarchy();
  ```

## Trade-offs

While the chosen technologies and strategies provide significant benefits, they come with their own set of trade-offs:

- **Complexity of CTEs**: Although CTEs greatly simplify the management of recursive queries, they can add complexity to the SQL code, potentially making it harder for new developers to understand and modify. Furthermore, while CTEs are powerful, they can lead to performance issues if not properly optimized, especially with extremely large datasets.

- **Caching Overheads**: Implementing caching improves response times but also introduces the complexity of cache management, such as ensuring cache coherence and handling cache invalidation properly. Over-reliance on caching can also mask underlying performance issues in database design and query optimization.

- **Database Load**: While PostgreSQL handles large volumes of data well, the choice of database and its configuration must be carefully managed as the application scales. The use of advanced features like CTEs and potentially large transaction volumes can strain the database unless properly indexed and tuned. To mitigate these issues, implementing database **partitioning** and **replication** can be highly effective:
  - **Partitioning**: Database partitioning involves dividing table data into multiple pieces. This can improve query performance and simplify maintenance because each partition can be managed independently. Partitioning can also help by reducing the load on individual database servers through data distribution.
  - **Replication**: Replication involves copying and distributing data and database objects from one database to another and synchronizing between databases to maintain consistency. Using replication can increase the availability of data by allowing read load to be distributed across multiple copies of the data, thereby enhancing the read performance and providing redundancy and failover capabilities.

## Conclusion

This solution is designed to be robust, scalable, and efficient, addressing both current and future needs of the application. By integrating advanced features of PostgreSQL and utilizing Rails’ efficient caching, the application is well-equipped to handle increasing loads and complex data structures with ease.