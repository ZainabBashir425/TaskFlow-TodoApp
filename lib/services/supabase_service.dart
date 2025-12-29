import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;
  static Stream<List<Map<String, dynamic>>> get taskStream => client
      .from('tasks')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false);
}
