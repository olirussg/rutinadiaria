import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const RutinaTotalApp());
}

class RutinaTotalApp extends StatelessWidget {
  const RutinaTotalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rutina Total Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF6366F1),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF10B981),
          surface: Color(0xFF1E293B),
          background: Color(0xFF0F172A),
        ),
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const HabitsScreen(),
    const RemindersScreen(),
    const StatsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 768;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: const Color(0xFF1E293B),
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: const IconThemeData(color: Color(0xFF6366F1)),
              selectedLabelTextStyle: const TextStyle(
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelTextStyle: const TextStyle(color: Colors.white54),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Hoy'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.local_fire_department_outlined),
                  selectedIcon: Icon(Icons.local_fire_department),
                  label: Text('Hábitos'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.alarm_outlined),
                  selectedIcon: Icon(Icons.alarm),
                  label: Text('Alarmas'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart),
                  label: Text('Stats'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Ajustes'),
                ),
              ],
            ),
            const VerticalDivider(
              thickness: 1,
              width: 1,
              color: Colors.white10,
            ),
            Expanded(child: _screens[_currentIndex]),
          ],
        ),
      );
    }

    // Vista Móvil
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: const Color(0xFF6366F1),
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Hoy'),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: 'Hábitos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Alarmas'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
      ),
    );
  }
}

// ==========================================
// PESTAÑA 1: DASHBOARD / RUTINA DIARIA
// ==========================================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedCategory = 'Todos';
  int _selectedMoodIndex = 1;
  final List<String> _moods = ['😄', '🙂', '😐', '🥱', '😫'];

  final List<Map<String, dynamic>> _activities = [
    {
      'title': 'Agua en ayunas (500ml)',
      'time': '07:00 AM',
      'category': 'Mañana',
      'isDone': true,
      'note': 'Tomar con limón tibio',
      'priority': 'Alta',
    },
    {
      'title': 'Ejercicio matutino / Cardio',
      'time': '07:30 AM',
      'category': 'Mañana',
      'isDone': false,
      'note': '20 min de alta intensidad',
      'priority': 'Alta',
    },
    {
      'title': 'Desayuno Nutritivo',
      'time': '08:30 AM',
      'category': 'Mañana',
      'isDone': false,
      'note': 'Avena y huevos',
      'priority': 'Media',
    },
    {
      'title': 'Trabajo / Programación en C#',
      'time': '10:00 AM',
      'category': 'Trabajo',
      'isDone': false,
      'note': 'Avanzar módulo de base de datos SQL',
      'priority': 'Alta',
    },
    {
      'title': 'Almuerzo Balanceado',
      'time': '01:00 PM',
      'category': 'Tarde',
      'isDone': false,
      'note': 'Proteína y vegetales',
      'priority': 'Media',
    },
    {
      'title': 'Lectura y Desarrollo Personal',
      'time': '09:00 PM',
      'category': 'Noche',
      'isDone': false,
      'note': '15 minutos de libros técnicos',
      'priority': 'Baja',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredActivities = _selectedCategory == 'Todos'
        ? _activities
        : _activities.where((a) => a['category'] == _selectedCategory).toList();

    int completed = _activities.where((a) => a['isDone'] == true).length;
    double progress = _activities.isEmpty ? 0 : completed / _activities.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rutina Total & Reminder Pro',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_active,
              color: Color(0xFF6366F1),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Sistema de recordatorios literales en segundo plano activo.',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TARJETA DE PROGRESO DIARIO
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF334155)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progreso del Día',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}% Completado',
                        style: const TextStyle(
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white10,
                    color: const Color(0xFF6366F1),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$completed de ${_activities.length} tareas completadas. ¡Sigue así!',
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ESTADO DE ÁNIMO
            const Text(
              '¿Cómo te sientes hoy?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_moods.length, (index) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedMoodIndex = index),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _selectedMoodIndex == index
                          ? const Color(0xFF6366F1)
                          : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selectedMoodIndex == index
                            ? Colors.white
                            : Colors.white10,
                      ),
                    ),
                    child: Text(
                      _moods[index],
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // FILTROS DE CATEGORÍA
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Todos', 'Mañana', 'Tarde', 'Noche', 'Trabajo'].map((
                  cat,
                ) {
                  bool isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: const Color(0xFF6366F1),
                      backgroundColor: const Color(0xFF1E293B),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                      ),
                      onSelected: (bool selected) {
                        setState(() => _selectedCategory = cat);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // CABECERA LISTA DE ACTIVIDADES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Actividades ($_selectedCategory)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: _showAddActivityDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Agregar'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // LISTA DE TAREAS
            filteredActivities.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        'No hay actividades en esta categoría',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredActivities.length,
                    itemBuilder: (context, index) {
                      final item = filteredActivities[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Checkbox(
                            value: item['isDone'],
                            activeColor: const Color(0xFF6366F1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (val) {
                              setState(() {
                                item['isDone'] = val;
                              });
                            },
                          ),
                          title: Text(
                            item['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: item['isDone']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: item['isDone']
                                  ? Colors.white54
                                  : Colors.white,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: Colors.white54,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item['time'],
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: item['priority'] == 'Alta'
                                          ? Colors.red.withOpacity(0.2)
                                          : Colors.blue.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item['priority'],
                                      style: TextStyle(
                                        color: item['priority'] == 'Alta'
                                            ? Colors.redAccent
                                            : Colors.blueAccent,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (item['note'] != null &&
                                  item['note'].isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item['note'],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _activities.remove(item);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6366F1),
        onPressed: _showAddActivityDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddActivityDialog() {
    final titleCtrl = TextEditingController();
    final timeCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    String category = 'Mañana';
    String priority = 'Media';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Nueva Actividad o Recordatorio'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la actividad',
                  icon: Icon(Icons.task),
                ),
              ),
              TextField(
                controller: timeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Hora (ej: 08:30 AM)',
                  icon: Icon(Icons.access_time),
                ),
              ),
              TextField(
                controller: noteCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nota detallada',
                  icon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                dropdownColor: const Color(0xFF0F172A),
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: ['Mañana', 'Tarde', 'Noche', 'Trabajo'].map((val) {
                  return DropdownMenuItem(value: val, child: Text(val));
                }).toList(),
                onChanged: (val) => category = val!,
              ),
              DropdownButtonFormField<String>(
                value: priority,
                dropdownColor: const Color(0xFF0F172A),
                decoration: const InputDecoration(labelText: 'Prioridad'),
                items: ['Alta', 'Media', 'Baja'].map((val) {
                  return DropdownMenuItem(value: val, child: Text(val));
                }).toList(),
                onChanged: (val) => priority = val!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
            ),
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                setState(() {
                  _activities.add({
                    'title': titleCtrl.text,
                    'time': timeCtrl.text.isEmpty ? '12:00 PM' : timeCtrl.text,
                    'category': category,
                    'isDone': false,
                    'note': noteCtrl.text,
                    'priority': priority,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// PESTAÑA 2: HÁBITOS Y RACHAS
// ==========================================
class HabitsScreen extends StatefulWidget {
  const HabitsScreen({Key? key}) : super(key: key);

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final List<Map<String, dynamic>> _habits = [
    {'name': 'Programar 1 hora diaria', 'streak': 12, 'doneToday': true},
    {'name': 'Beber 2.5 Litros de Agua', 'streak': 5, 'doneToday': false},
    {'name': 'Entrenamiento de Fuerza', 'streak': 3, 'doneToday': false},
    {'name': 'Estudiar C# / SQL / Flutter', 'streak': 8, 'doneToday': true},
    {'name': 'Rutina de Skincare Nocturna', 'streak': 15, 'doneToday': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguimiento de Hábitos'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _habits.length,
        itemBuilder: (context, index) {
          final habit = _habits[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${habit['streak']} días de racha continua 🔥',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: habit['doneToday'],
                  activeColor: const Color(0xFF6366F1),
                  onChanged: (val) {
                    setState(() {
                      habit['doneToday'] = val;
                      if (val) {
                        habit['streak'] += 1;
                      } else {
                        habit['streak'] -= 1;
                      }
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// PESTAÑA 3: RECORDATORIOS Y ALARMAS
// ==========================================
class RemindersScreen extends StatelessWidget {
  const RemindersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alarms = [
      {
        'title': 'Alerta de Hidratación',
        'time': 'Cada 2 horas',
        'active': true,
      },
      {'title': 'Descanso de Pantalla', 'time': '03:00 PM', 'active': true},
      {
        'title': 'Tomar Medicamentos / Vitaminas',
        'time': '08:00 AM',
        'active': false,
      },
      {
        'title': 'Revisión de Metas Nocturnas',
        'time': '10:00 PM',
        'active': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarmas y Avisos Literales'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          final alarm = alarms[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SwitchListTile(
              title: Text(
                alarm['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Programado: ${alarm['time']}',
                style: const TextStyle(color: Colors.white54),
              ),
              secondary: const Icon(Icons.alarm, color: Color(0xFF6366F1)),
              value: alarm['active'] as bool,
              activeColor: const Color(0xFF6366F1),
              onChanged: (val) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Alarma "${alarm['title']}" ${val ? "activada" : "desactivada"}.',
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// PESTAÑA 4: ESTADÍSTICAS
// ==========================================
class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas de Productividad'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Efectividad',
                    '88%',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Racha Máxima',
                    '15 Días',
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Tareas Totales',
                    '42',
                    Icons.task_alt,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Hábitos Activos',
                    '5',
                    Icons.star,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen Semanal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '¡Excelente trabajo! Has mantenido un ritmo constante en tus proyectos de software y rutinas personales. Tu constancia ha mejorado un 14% respecto a la semana pasada.',
                    style: TextStyle(color: Colors.white70, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// PESTAÑA 5: AJUSTES
// ==========================================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes y Preferencias'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'GENERAL',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Notificaciones Push y Sonido'),
            subtitle: const Text(
              'Recibe recordatorios literales en tiempo real',
            ),
            value: true,
            activeColor: const Color(0xFF6366F1),
            onChanged: (val) {},
          ),
          SwitchListTile(
            title: const Text('Modo Oscuro Absoluto'),
            subtitle: const Text('Optimizado para pantallas OLED y desarrollo'),
            value: true,
            activeColor: const Color(0xFF6366F1),
            onChanged: (val) {},
          ),
          const Divider(height: 32, color: Colors.white10),
          const Text(
            'DATOS Y RESPALDO',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(
              Icons.cloud_upload_outlined,
              color: Color(0xFF6366F1),
            ),
            title: const Text('Exportar datos de rutina'),
            subtitle: const Text('Guardar copia de seguridad en JSON'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Datos exportados exitosamente.')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.refresh, color: Colors.orangeAccent),
            title: const Text('Restablecer valores predeterminados'),
            subtitle: const Text('Reinicia la rutina diaria base'),
            onTap: () {},
          ),
          const Divider(height: 32, color: Colors.white10),
          const Text(
            'ACERCA DE',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const ListTile(
            leading: Icon(Icons.info_outline, color: Colors.white70),
            title: Text('Rutina Total Pro'),
            subtitle: Text('Versión 2.5.0 • Multiplataforma Flutter'),
          ),
        ],
      ),
    );
  }
}
