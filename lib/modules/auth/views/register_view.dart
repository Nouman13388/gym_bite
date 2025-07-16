import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    InputDecoration _themedDecoration({
      required String label,
      IconData? icon,
      bool isPassword = false,
      VoidCallback? onTogglePassword,
    }) => InputDecoration(
      labelText: label,
      labelStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface.withOpacity(0.8),
      ),
      floatingLabelStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      prefixIcon:
          icon != null ? Icon(icon, color: colorScheme.onSurface) : null,
      suffixIcon:
          isPassword && onTogglePassword != null
              ? Obx(
                () => IconButton(
                  icon: Icon(
                    controller.passwordVisible.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  onPressed: onTogglePassword,
                  tooltip:
                      controller.passwordVisible.value
                          ? 'Hide Password'
                          : 'Show Password',
                ),
              )
              : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
    Widget _buildTextField({
      required String label,
      required TextEditingController controllerField,
      IconData? icon,
      bool isPassword = false,
      VoidCallback? onTogglePassword,
      String? Function(String?)? validator,
      TextInputType? keyboardType,
      bool autofocus = false,
      TextInputAction? textInputAction,
      List<String>? autofillHints,
    }) {
      if (isPassword) {
        return Obx(
          () => TextFormField(
            controller: controllerField,
            decoration: _themedDecoration(
              label: label,
              icon: icon,
              isPassword: isPassword,
              onTogglePassword: onTogglePassword,
            ),
            obscureText: !controller.passwordVisible.value,
            style: textTheme.bodyLarge,
            validator: validator,
            keyboardType: keyboardType,
            autofocus: autofocus,
            textInputAction: textInputAction,
            autofillHints: autofillHints,
          ),
        );
      } else {
        return TextFormField(
          controller: controllerField,
          decoration: _themedDecoration(
            label: label,
            icon: icon,
            isPassword: isPassword,
            onTogglePassword: onTogglePassword,
          ),
          obscureText: false,
          style: textTheme.bodyLarge,
          validator: validator,
          keyboardType: keyboardType,
          autofocus: autofocus,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
        );
      }
    }

    Widget _buildDropdown() => DropdownButtonFormField<String>(
      value: controller.selectedRole.value,
      items: const [
        DropdownMenuItem(value: 'CLIENT', child: Text('Client')),
        DropdownMenuItem(value: 'TRAINER', child: Text('Trainer')),
      ],
      onChanged: (value) {
        if (value != null) controller.selectedRole.value = value;
      },
      decoration: _themedDecoration(label: 'Role', icon: Icons.person),
      style: textTheme.bodyLarge,
      dropdownColor: colorScheme.background,
      validator:
          (val) => val == null || val.isEmpty ? 'Role is required' : null,
    );
    Widget _buildTrainerFields() => Column(
      children: [
        _buildTextField(
          label: 'Specialty',
          controllerField: controller.specialtyController,
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Experience (Years)',
          controllerField: controller.experienceYearsController,
          keyboardType: TextInputType.number,
          validator:
              (val) =>
                  val == null || val.isEmpty
                      ? 'Required'
                      : (int.tryParse(val) == null ? 'Enter a number' : null),
          textInputAction: TextInputAction.next,
        ),
      ],
    );
    Widget _buildClientFields() => Column(
      children: [
        _buildTextField(
          label: 'Weight (kg)',
          controllerField: controller.weightController,
          icon: Icons.fitness_center_outlined,
          keyboardType: TextInputType.number,
          validator:
              (val) =>
                  val == null || val.isEmpty
                      ? 'Required'
                      : (double.tryParse(val) == null
                          ? 'Enter a number'
                          : null),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Height (cm)',
          controllerField: controller.heightController,
          icon: Icons.height_outlined,
          keyboardType: TextInputType.number,
          validator:
              (val) =>
                  val == null || val.isEmpty
                      ? 'Required'
                      : (double.tryParse(val) == null
                          ? 'Enter a number'
                          : null),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'BMI',
          controllerField: controller.bmiController,
          icon: Icons.calculate_outlined,
          keyboardType: TextInputType.number,
          validator:
              (val) =>
                  val == null || val.isEmpty
                      ? 'Required'
                      : (double.tryParse(val) == null
                          ? 'Enter a number'
                          : null),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Fitness Goals',
          controllerField: controller.fitnessGoalsController,
          icon: Icons.directions_run_outlined,
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Dietary Preferences',
          controllerField: controller.dietaryPreferencesController,
          icon: Icons.restaurant_menu_outlined,
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        titleTextStyle: textTheme.titleLarge?.copyWith(fontSize: 25),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  label: 'Full Name',
                  controllerField: controller.nameController,
                  icon: Icons.person_outline,
                  validator:
                      (val) => val == null || val.isEmpty ? 'Required' : null,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Email',
                  controllerField: controller.emailController,
                  icon: Icons.email_outlined,
                  validator:
                      (val) =>
                          val == null || val.isEmpty
                              ? 'Required'
                              : (!GetUtils.isEmail(val)
                                  ? 'Enter a valid email'
                                  : null),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Password',
                  controllerField: controller.passwordController,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  onTogglePassword:
                      () =>
                          controller.passwordVisible.value =
                              !controller.passwordVisible.value,
                  validator:
                      (val) =>
                          val == null || val.isEmpty
                              ? 'Required'
                              : (val.length < 6 ? 'Min 6 chars' : null),
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.password],
                ),
                const SizedBox(height: 16),
                _buildDropdown(),
                const SizedBox(height: 16),
                Obx(
                  () =>
                      controller.selectedRole.value == 'TRAINER'
                          ? _buildTrainerFields()
                          : _buildClientFields(),
                ),
                const SizedBox(height: 24),
                Obx(
                  () => ElevatedButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : () {
                              if (controller.formKey.currentState?.validate() ??
                                  false) {
                                controller.register();
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      disabledBackgroundColor: colorScheme.surfaceVariant,
                      disabledForegroundColor: colorScheme.onSurface
                          .withOpacity(0.38),
                    ),
                    child:
                        controller.isLoading.value
                            ? SizedBox(
                              height: 28,
                              width: 28,
                              child: CircularProgressIndicator(
                                color: colorScheme.onPrimary,
                                strokeWidth: 2.2,
                              ),
                            )
                            : Text(
                              'Register',
                              style: textTheme.labelLarge?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Already have an account? Login',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.secondary,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
