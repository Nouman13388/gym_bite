import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    InputDecoration themedDecoration({
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Modern heading
                      Text(
                        'Login',
                        style: textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: controller.emailController,
                        decoration: themedDecoration(
                          label: 'Email',
                          icon: Icons.email_outlined,
                        ),
                        style: textTheme.bodyLarge,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? 'Email is required'
                                    : (!GetUtils.isEmail(val)
                                        ? 'Enter a valid email'
                                        : null),
                        onFieldSubmitted:
                            (_) => FocusScope.of(context).nextFocus(),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => TextFormField(
                          controller: controller.passwordController,
                          obscureText: !controller.passwordVisible.value,
                          decoration: themedDecoration(
                            label: 'Password',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            onTogglePassword:
                                () =>
                                    controller.passwordVisible.value =
                                        !controller.passwordVisible.value,
                          ),
                          style: textTheme.bodyLarge,
                          autofillHints: const [AutofillHints.password],
                          textInputAction: TextInputAction.done,
                          validator:
                              (val) =>
                                  val == null || val.isEmpty
                                      ? 'Password is required'
                                      : (val.length < 6 ? 'Min 6 chars' : null),
                          onFieldSubmitted:
                              (_) => FocusScope.of(context).unfocus(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Obx(
                        () => ElevatedButton(
                          onPressed:
                              controller.isLoading.value
                                  ? null
                                  : () {
                                    if (controller.formKey.currentState
                                            ?.validate() ??
                                        false) {
                                      controller.login();
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
                                    'Login',
                                    style: textTheme.labelLarge?.copyWith(
                                      color: colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Get.toNamed('/register'),
                        child: Text(
                          "Don't have an account? Register",
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
        },
      ),
    );
  }
}
