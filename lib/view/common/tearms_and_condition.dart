import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logic_study/theme/colors.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return SizedBox(
        height: size.maxHeight,
        child: const SingleChildScrollView(
            child: Column(
          children: [
            TextContent('قبول الشروط',
                'في منصة لوجك ستدي الالكترونية للتنمية المستدامة ، نفهم أهمية الخصوصية والأمان لمعلوماتك الشخصية. نلتزم بحماية خصوصيتك وفقًا لأعلى المعايير والقوانين المحلية والدولية. سياسة الخصوصية هذه توضح بشكل مفصل كيفية جمعنا، استخدامنا، وحمايتنا لمعلوماتك الشخصية.'),
            TextContent(
              'جمع المعلومات',
              'بالإضافة إلى البيانات الشخصية الأساسية، نجمع معلومات عن تفضيلاتك وسلوكك داخل التطبيق لتحسين تجربتك. نستخدم تقنيات مثل الكوكيز وأدوات التحليل لجمع بيانات حول كيفية استخدامك للتطبيق وتحسين خدماتنا.',
            ),
            TextContent(
              'استخدام المعلومات',
              'نستخدم بياناتك لتخصيص المحتوى والتوصيات، ولتقديم دعم العملاء. قد نستخدم معلوماتك في الأبحاث والتحليلات لتطوير منتجات وخدمات جديدة.',
            ),
            TextContent(
              'مشاركة المعلومات',
              'نضمن أن جميع الأطراف الثالثة التي نشارك معها معلوماتك ملتزمة بحماية بياناتك واستخدامها بشكل مسؤول. نقوم بمراجعة دورية لسياسات الخصوصية للشركاء لضمان التزامهم بمعايير الخصوصية المطلوبة.',
            ),
            TextContent(
              'حماية المعلومات',
              'نستخدم تشفيرًا متطورًا وتقنيات أمان أخرى لحماية بياناتك من الوصول غير المصرح به. نقوم بتدريب موظفينا بانتظام على أفضل ممارسات الخصوصية والأمان.',
            ),
            TextContent(
              'حقوق المستخدم',
              'لديك الحق في الاعتراض على معالجة بياناتك الشخصية لأغراض التسويق المباشر. يمكنك الوصول إلى سجلات معلوماتك الشخصية والحصول على نسخة منها بتنسيق مقروء آليًا.',
            ),
            TextContent(
              'التغييرات على سياسة الخصوصية',
              'سيتم نشر أي تغييرات على سياسة الخصوصية على موقعنا الإلكتروني وداخل التطبيق مع توضيح التغييرات المحدثة بوضوح. نشجع المستخدمين على مراجعة سياسة الخصوصية بانتظام للبقاء على علم بأي تحديثات.',
            ),
            TextContent(
              'الاتصال بنا',
              'لأي استفسارات أو مخاوف بشأن سياسة الخصوصية هذه أو ممارسات الخصوصية لدينا، يرجى التواصل مع فريق الدعم',
            ),
            SafeArea(
              child: SizedBox(
                height: 25,
              ),
            )
          ],
        )),
      );
    });
  }
}

class TextContent extends StatelessWidget {
  const TextContent(
    this.title,
    this.desc, {
    super.key,
  });

  final String? title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsetsDirectional.only(end: 10, top: 2),
                    height: 20,
                    width: 3,
                    color: AppColors.primary,
                  ),
                  Text(
                    title!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          Text(
            desc.tr,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
