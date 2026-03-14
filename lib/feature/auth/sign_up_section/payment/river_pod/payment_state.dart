class PaymentState{

  final bool isLoading;
  final bool cuponLoading;
  final bool paymentLoading;

  PaymentState({
    this.isLoading = false,
    this.cuponLoading = false,
    this.paymentLoading = false,


});

  PaymentState copyWith({
    bool? isLoading,
    bool? cuponLoading,
    bool? paymentLoading,
}){
    return PaymentState(
      isLoading: isLoading?? this.isLoading,
      cuponLoading: cuponLoading??this.cuponLoading,
      paymentLoading: paymentLoading??this.paymentLoading
    );
}
}